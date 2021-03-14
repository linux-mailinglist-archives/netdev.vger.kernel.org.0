Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5316733A3FD
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 10:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235088AbhCNJyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 05:54:17 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:48035 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229495AbhCNJx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 05:53:58 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id C458958086F;
        Sun, 14 Mar 2021 05:53:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 14 Mar 2021 05:53:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=GmvxaH
        HP++oUz4zIydmbNhlkLE/p8XuZ+CjSkD0groA=; b=P8UIacQNjkm6t2QvH8d1+r
        B7/N7BgUlb3a8wQDXG79uqPOpji+t9MGXc2mY+ENhMUhx2Pjd5Z9ZkPn2uCmujg3
        NwGSpfztgs1uFg+aG97rg3Dc9KDOqsE8QFPld0sd75fyEZP3SOxOVlydqftaw4LN
        g7a+VsXgktM5RwEkaRHmd4qyIWQvDMQYnGZvOv5CaXjmaHehhRC0q8zx51xC9yuU
        cZvLUdr9ffuuP2iOB56uczgf5W99ZU0Khtc3oYxWI9BZpD2UYPHSyqGKUlpFZM0t
        PTRb2XPkHSV2XCzLeo6K+j9VVHzxFOY4YV/gExPkrW7dJGYQN7QlhcvfbWSI0sGw
        ==
X-ME-Sender: <xms:M91NYIqqJJIZcphg6UQBYQwZU5OChTzbEvkx-YPlU1d3sl_YqPdE-w>
    <xme:M91NYOq0Albq-6YLN0fSzQ_1yAFhqj284qw1vKEPVXK81qnqjZvkuh-dXyLDLr4S5
    Y3CM92r_VRbPrc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddviecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgthhhi
    mhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvghrnh
    eptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleetnecu
    kfhppeekgedrvddvledrudehfedrgeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:M91NYNObybiV5C37A6lCn72eg0CfkMdiEw58cN14ef_FWh6qiagZPw>
    <xmx:M91NYP5WPrVjqbNKBUqhtBja4egnirvYtsj907OLyF2zs2LDuph3Lw>
    <xmx:M91NYH4CH-BY-Se21G9-hfLVSCHvPXJiHdxdRJh6OBWiHBA9U8TbcA>
    <xmx:NN1NYKZNi4j-HxeMkzyDTAr0WCuXBtJmCacZntrJ5I81IkS4xf1k-w>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 660C4108005F;
        Sun, 14 Mar 2021 05:53:55 -0400 (EDT)
Date:   Sun, 14 Mar 2021 11:53:52 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        lukasz.luba@arm.com, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Kucheria <amitk@kernel.org>,
        "open list:MELLANOX ETHERNET SWITCH DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] thermal/drivers/core: Use a char pointer for the
 cooling device name
Message-ID: <YE3dMM7tqk5BbD/l@shredder.lan>
References: <20210312170316.3138-1-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312170316.3138-1-daniel.lezcano@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 06:03:12PM +0100, Daniel Lezcano wrote:
> diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
> index 996c038f83a4..9ef8090eb645 100644
> --- a/drivers/thermal/thermal_core.c
> +++ b/drivers/thermal/thermal_core.c
> @@ -960,10 +960,7 @@ __thermal_cooling_device_register(struct device_node *np,
>  {
>  	struct thermal_cooling_device *cdev;
>  	struct thermal_zone_device *pos = NULL;
> -	int result;
> -
> -	if (type && strlen(type) >= THERMAL_NAME_LENGTH)
> -		return ERR_PTR(-EINVAL);
> +	int ret;
>  
>  	if (!ops || !ops->get_max_state || !ops->get_cur_state ||
>  	    !ops->set_cur_state)
> @@ -973,14 +970,17 @@ __thermal_cooling_device_register(struct device_node *np,
>  	if (!cdev)
>  		return ERR_PTR(-ENOMEM);
>  
> -	result = ida_simple_get(&thermal_cdev_ida, 0, 0, GFP_KERNEL);
> -	if (result < 0) {
> -		kfree(cdev);
> -		return ERR_PTR(result);
> +	ret = ida_simple_get(&thermal_cdev_ida, 0, 0, GFP_KERNEL);
> +	if (ret < 0)
> +		goto out_kfree_cdev;
> +	cdev->id = ret;
> +
> +	cdev->type = kstrdup(type ? type : "", GFP_KERNEL);
> +	if (!cdev->type) {
> +		ret = -ENOMEM;
> +		goto out_ida_remove;
>  	}
>  
> -	cdev->id = result;
> -	strlcpy(cdev->type, type ? : "", sizeof(cdev->type));
>  	mutex_init(&cdev->lock);
>  	INIT_LIST_HEAD(&cdev->thermal_instances);
>  	cdev->np = np;
> @@ -990,12 +990,9 @@ __thermal_cooling_device_register(struct device_node *np,
>  	cdev->devdata = devdata;
>  	thermal_cooling_device_setup_sysfs(cdev);
>  	dev_set_name(&cdev->device, "cooling_device%d", cdev->id);
> -	result = device_register(&cdev->device);
> -	if (result) {
> -		ida_simple_remove(&thermal_cdev_ida, cdev->id);
> -		put_device(&cdev->device);
> -		return ERR_PTR(result);
> -	}
> +	ret = device_register(&cdev->device);
> +	if (ret)
> +		goto out_kfree_type;
>  
>  	/* Add 'this' new cdev to the global cdev list */
>  	mutex_lock(&thermal_list_lock);
> @@ -1013,6 +1010,14 @@ __thermal_cooling_device_register(struct device_node *np,
>  	mutex_unlock(&thermal_list_lock);
>  
>  	return cdev;
> +
> +out_kfree_type:
> +	kfree(cdev->type);
> +	put_device(&cdev->device);
> +out_ida_remove:
> +	ida_simple_remove(&thermal_cdev_ida, cdev->id);
> +out_kfree_cdev:
> +	return ERR_PTR(ret);
>  }
>  
>  /**
> @@ -1172,6 +1177,7 @@ void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
>  	device_del(&cdev->device);
>  	thermal_cooling_device_destroy_sysfs(cdev);
>  	put_device(&cdev->device);
> +	kfree(cdev->type);
>  }
>  EXPORT_SYMBOL_GPL(thermal_cooling_device_unregister);

I'm getting the following user-after-free with this patch [1]. Fixed by:

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 9ef8090eb645..c8d4010940ef 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1176,8 +1176,8 @@ void thermal_cooling_device_unregister(struct thermal_cooling_device *cdev)
        ida_simple_remove(&thermal_cdev_ida, cdev->id);
        device_del(&cdev->device);
        thermal_cooling_device_destroy_sysfs(cdev);
-       put_device(&cdev->device);
        kfree(cdev->type);
+       put_device(&cdev->device);
 }
 EXPORT_SYMBOL_GPL(thermal_cooling_device_unregister);

[1]
[  148.601815] ==================================================================
[  148.610260] BUG: KASAN: use-after-free in thermal_cooling_device_unregister+0x6ca/0x6e0
[  148.619304] Read of size 8 at addr ffff8881510a0808 by task devlink/574
[  148.626768]
[  148.628477] CPU: 2 PID: 574 Comm: devlink Not tainted 5.12.0-rc2-custom-12525-g7ba8a2feee15 #3301
[  148.638463] Hardware name: Mellanox Technologies Ltd. MSN2100-CB2FO/SA001017, BIOS 5.6.5 06/07/2016
[  148.648625] Call Trace:
[  148.651408]  dump_stack+0xfa/0x151
[  148.661701]  print_address_description.constprop.0+0x18/0x130
[  148.681014]  kasan_report.cold+0x7f/0x111
[  148.692003]  thermal_cooling_device_unregister+0x6ca/0x6e0
[  148.703984]  mlxsw_thermal_fini+0xd2/0x1f0
[  148.708664]  mlxsw_core_bus_device_unregister+0x158/0x8d0
[  148.714794]  mlxsw_devlink_core_bus_device_reload_down+0x93/0xc0
[  148.721594]  devlink_reload+0x15f/0x5e0
[  148.749669]  devlink_nl_cmd_reload+0x7fc/0x1210
[  148.775992]  genl_family_rcv_msg_doit+0x22a/0x320
[  148.799789]  genl_rcv_msg+0x341/0x5a0
[  148.818789]  netlink_rcv_skb+0x14d/0x430
[  148.836450]  genl_rcv+0x29/0x40
[  148.840034]  netlink_unicast+0x539/0x7e0
[  148.859219]  netlink_sendmsg+0x8d7/0xe10
[  148.879271]  __sys_sendto+0x23f/0x350
[  148.904178]  __x64_sys_sendto+0xe2/0x1b0
[  148.919297]  do_syscall_64+0x2d/0x40
[  148.923365]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  148.929081] RIP: 0033:0x7f17c0dbaefa
[  148.933139] Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb b8 0f 1f 00 f3 0f 1e fa 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 15 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 76
 c3 0f 1f 44 00 00 55 48 83 ec 30 44 89 4c
[  148.954190] RSP: 002b:00007ffd879c5e18 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  148.962723] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f17c0dbaefa
[  148.970751] RDX: 0000000000000030 RSI: 0000000000ad0ad0 RDI: 0000000000000003
[  148.978776] RBP: 0000000000ad0aa0 R08: 00007f17c0e8d000 R09: 000000000000000c
[  148.986803] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000408d70
[  148.994834] R13: 0000000000ad0910 R14: 0000000000000000 R15: 0000000000000001
[  149.002978]
[  149.004687] Allocated by task 1:
[  149.008345]  kasan_save_stack+0x1b/0x40
[  149.012711]  __kasan_kmalloc+0x7a/0x90
[  149.016974]  __thermal_cooling_device_register.part.0+0x59/0x9e0
[  149.023753]  thermal_cooling_device_register+0xb3/0x100
[  149.029671]  mlxsw_thermal_init+0x78b/0xa10
[  149.034427]  __mlxsw_core_bus_device_register+0xd05/0x1a30
[  149.040634]  mlxsw_core_bus_device_register+0x56/0xb0
[  149.046349]  mlxsw_pci_probe+0x53b/0x750
[  149.050800]  local_pci_probe+0xc6/0x170
[  149.055144]  pci_device_probe+0x2a3/0x4a0
[  149.059683]  really_probe+0x2b6/0xec0
[  149.063840]  driver_probe_device+0x1e2/0x330
[  149.068673]  device_driver_attach+0x282/0x2f0
[  149.073605]  __driver_attach+0x160/0x2f0
[  149.078050]  bus_for_each_dev+0x14c/0x1d0
[  149.082589]  bus_add_driver+0x3ac/0x650
[  149.086935]  driver_register+0x225/0x3a0
[  149.091381]  mlxsw_sp_module_init+0xa2/0x174
[  149.096216]  do_one_initcall+0x108/0x690
[  149.100660]  kernel_init_freeable+0x3ec/0x46b
[  149.105595]  kernel_init+0x13/0x1eb
[  149.109559]  ret_from_fork+0x1f/0x30
[  149.113613]
[  149.115311] Freed by task 574:
[  149.118765]  kasan_save_stack+0x1b/0x40
[  149.123116]  kasan_set_track+0x1c/0x30
[  149.127373]  kasan_set_free_info+0x20/0x30
[  149.132021]  __kasan_slab_free+0xe5/0x110
[  149.136556]  slab_free_freelist_hook+0x59/0x150
[  149.141681]  kfree+0xd5/0x3b0
[  149.145055]  thermal_release+0xa0/0x110
[  149.149414]  device_release+0xa4/0x240
[  149.153680]  kobject_put+0x1c8/0x540
[  149.157747]  put_device+0x20/0x30
[  149.161530]  thermal_cooling_device_unregister+0x578/0x6e0
[  149.167751]  mlxsw_thermal_fini+0xd2/0x1f0
[  149.172414]  mlxsw_core_bus_device_unregister+0x158/0x8d0
[  149.178529]  mlxsw_devlink_core_bus_device_reload_down+0x93/0xc0
[  149.185327]  devlink_reload+0x15f/0x5e0
[  149.189695]  devlink_nl_cmd_reload+0x7fc/0x1210
[  149.194838]  genl_family_rcv_msg_doit+0x22a/0x320
[  149.200182]  genl_rcv_msg+0x341/0x5a0
[  149.204337]  netlink_rcv_skb+0x14d/0x430
[  149.208799]  genl_rcv+0x29/0x40
[  149.212381]  netlink_unicast+0x539/0x7e0
[  149.216825]  netlink_sendmsg+0x8d7/0xe10
[  149.221274]  __sys_sendto+0x23f/0x350
[  149.225423]  __x64_sys_sendto+0xe2/0x1b0
[  149.229864]  do_syscall_64+0x2d/0x40
[  149.233912]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  149.239624]
[  149.241322] The buggy address belongs to the object at ffff8881510a0800
[  149.241322]  which belongs to the cache kmalloc-2k of size 2048
[  149.255372] The buggy address is located 8 bytes inside of
[  149.255372]  2048-byte region [ffff8881510a0800, ffff8881510a1000)
[  149.268456] The buggy address belongs to the page:
[  149.273850] page:000000006ec87a73 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1510a0
[  149.284416] head:000000006ec87a73 order:3 compound_mapcount:0 compound_pincount:0
[  149.292838] flags: 0x200000000010200(slab|head)
[  149.297981] raw: 0200000000010200 ffffea000426e208 ffffea000544b808 ffff88810004de40
[  149.306707] raw: 0000000000000000 0000000000050005 00000001ffffffff 0000000000000000
[  149.315417] page dumped because: kasan: bad access detected
[  149.321697]
[  149.323403] Memory state around the buggy address:
[  149.328811]  ffff8881510a0700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  149.336939]  ffff8881510a0780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  149.345075] >ffff8881510a0800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  149.353202]                       ^
[  149.357159]  ffff8881510a0880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  149.365298]  ffff8881510a0900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  149.373424] ==================================================================
