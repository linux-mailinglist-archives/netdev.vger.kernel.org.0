Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B570F20A055
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 15:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405253AbgFYNvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 09:51:33 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:44284 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405240AbgFYNvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 09:51:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593093090; x=1624629090;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qVX4+TcnztF8VPhRNCOlv7foy8E8Y/54kWK5GwgbcU4=;
  b=ReL20QXEefGQyDKHal9J5yuR9J3ja7ncXZ6RP4qXrdgx7tFFfIuiRan6
   1bvBM09neaKOk0CTibbdodPUiwmAt2M3iEtpksP0IXWpJuos8SXS0OrZI
   Pdojl+B9u0OsvHGfQyYgQTAn2m5zaUsncrmG5jfspYLI1PnsKBId70kwJ
   JKjJl+hdP7gREN6Zm7zPmUykb2UTVHr1u+cQ7s2bVdyODnrNTGMNLAaNO
   8/YSELu3wuW9b3emFYYD+m0LnFs5Q0onqqtlGvVwAwURO72mjTHPo/Rf8
   rs6aXB0xvWrbBRYSD0Gb8jaU69EJOTHuwZ8RzVmykBL6v44wrisEVNQCS
   g==;
IronPort-SDR: pHYlX11sgf1vpn9GQGvnkldQV4h0NNuoKTbkKjX4DB7j0lbOiJe2yPA3yj3QpclyuK3S8NTsQD
 WCzKA1IQ+bEKcO26so1OA2hFltXaWYx5wxGn4Cr+R1V/pP3q37n7mrb6A6VaNcPUbV8SgJ/Hmh
 GMTmI5WHFHLogp4c5L0Rc4aozbR5CR7Giom8mU4ZuXfxMmcBTg2z+sBbK5qYK+X7aYSfIhXENM
 9ECDf2TG/a80kAD0EbXU4GkVooF0WZ/ch0Lx5p8JaR5nL0CC6a6IrQtRtb9GUr19ENCkeMViIF
 UWI=
X-IronPort-AV: E=Sophos;i="5.75,279,1589266800"; 
   d="scan'208";a="17036083"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Jun 2020 06:51:30 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Jun 2020 06:51:30 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 25 Jun 2020 06:51:16 -0700
Date:   Thu, 25 Jun 2020 15:51:27 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
CC:     kernel test robot <lkp@intel.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <kbuild-all@lists.01.org>
Subject: Re: [PATCH net-next v2] bridge: mrp: Extend MRP netlink interface
 with IFLA_BRIDGE_MRP_CLEAR
Message-ID: <20200625135127.qfej3r2kbhbqjl55@soft-dev3.localdomain>
References: <20200625070630.3267620-1-horatiu.vultur@microchip.com>
 <202006251953.iZkqIUMb%lkp@intel.com>
 <e0c847b9-8af5-c24f-8813-cffb388e3e23@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <e0c847b9-8af5-c24f-8813-cffb388e3e23@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 06/25/2020 15:17, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On 25/06/2020 15:03, kernel test robot wrote:
> > Hi Horatiu,
> >
> > Thank you for the patch! Perhaps something to improve:
> >
> 
Hi Nik,

> Hi,
> I think you should drop the __rcu tag for the mrp_list member and also
> from the "list" member of struct br_mrp to fix most of the below.
> 
> Cheers,
>  Nik

Thanks, your suggestion worked. I really had problems understanding
these sparse warnings.
I will move this patch in a patch series where I will fix also these
warnings.

> 
> > [auto build test WARNING on net-next/master]
> >
> > url:    https://github.com/0day-ci/linux/commits/Horatiu-Vultur/bridge-mrp-Extend-MRP-netlink-interface-with-IFLA_BRIDGE_MRP_CLEAR/20200625-150941
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 147373d968f1c1b5d6bb71e4e8b7495eeb9cdcae
> > config: i386-randconfig-s001-20200624 (attached as .config)
> > compiler: gcc-9 (Debian 9.3.0-13) 9.3.0
> > reproduce:
> >         # apt-get install sparse
> >         # sparse version: v0.6.2-dirty
> >         # save the attached .config to linux build tree
> >         make W=1 C=1 ARCH=i386 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> >
> > sparse warnings: (new ones prefixed by >>)
> >
> >    net/bridge/br_mrp.c:106:18: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned short [usertype] @@     got restricted __be16 [usertype] @@
> >    net/bridge/br_mrp.c:106:18: sparse:     expected unsigned short [usertype]
> >    net/bridge/br_mrp.c:106:18: sparse:     got restricted __be16 [usertype]
> >    net/bridge/br_mrp.c:281:23: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected struct list_head *entry @@     got struct list_head [noderef] * @@
> >    net/bridge/br_mrp.c:281:23: sparse:     expected struct list_head *entry
> >    net/bridge/br_mrp.c:281:23: sparse:     got struct list_head [noderef] *
> >    net/bridge/br_mrp.c:332:28: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected struct list_head *new @@     got struct list_head [noderef] * @@
> >    net/bridge/br_mrp.c:332:28: sparse:     expected struct list_head *new
> >    net/bridge/br_mrp.c:332:28: sparse:     got struct list_head [noderef] *
> >    net/bridge/br_mrp.c:332:40: sparse: sparse: incorrect type in argument 2 (different modifiers) @@     expected struct list_head *head @@     got struct list_head [noderef] * @@
> >    net/bridge/br_mrp.c:332:40: sparse:     expected struct list_head *head
> >    net/bridge/br_mrp.c:332:40: sparse:     got struct list_head [noderef] *
> >    net/bridge/br_mrp.c:691:29: sparse: sparse: incorrect type in argument 1 (different modifiers) @@     expected struct list_head const *head @@     got struct list_head [noderef] * @@
> >    net/bridge/br_mrp.c:691:29: sparse:     expected struct list_head const *head
> >    net/bridge/br_mrp.c:691:29: sparse:     got struct list_head [noderef] *
> >>> net/bridge/br_mrp.c:383:9: sparse: sparse: dereference of noderef expression
> >>> net/bridge/br_mrp.c:383:9: sparse: sparse: dereference of noderef expression
> >>> net/bridge/br_mrp.c:383:9: sparse: sparse: dereference of noderef expression
> >
> > vim +383 net/bridge/br_mrp.c
> >
> >    284
> >    285        /* Adds a new MRP instance.
> >    286         * note: called under rtnl_lock
> >    287         */
> >    288        int br_mrp_add(struct net_bridge *br, struct br_mrp_instance *instance)
> >    289        {
> >    290                struct net_bridge_port *p;
> >    291                struct br_mrp *mrp;
> >    292                int err;
> >    293
> >    294                /* If the ring exists, it is not possible to create another one with the
> >    295                 * same ring_id
> >    296                 */
> >    297                mrp = br_mrp_find_id(br, instance->ring_id);
> >    298                if (mrp)
> >    299                        return -EINVAL;
> >    300
> >    301                if (!br_mrp_get_port(br, instance->p_ifindex) ||
> >    302                    !br_mrp_get_port(br, instance->s_ifindex))
> >    303                        return -EINVAL;
> >    304
> >    305                /* It is not possible to have the same port part of multiple rings */
> >    306                if (!br_mrp_unique_ifindex(br, instance->p_ifindex) ||
> >    307                    !br_mrp_unique_ifindex(br, instance->s_ifindex))
> >    308                        return -EINVAL;
> >    309
> >    310                mrp = kzalloc(sizeof(*mrp), GFP_KERNEL);
> >    311                if (!mrp)
> >    312                        return -ENOMEM;
> >    313
> >    314                mrp->ring_id = instance->ring_id;
> >    315                mrp->prio = instance->prio;
> >    316
> >    317                p = br_mrp_get_port(br, instance->p_ifindex);
> >    318                spin_lock_bh(&br->lock);
> >    319                p->state = BR_STATE_FORWARDING;
> >    320                p->flags |= BR_MRP_AWARE;
> >    321                spin_unlock_bh(&br->lock);
> >    322                rcu_assign_pointer(mrp->p_port, p);
> >    323
> >    324                p = br_mrp_get_port(br, instance->s_ifindex);
> >    325                spin_lock_bh(&br->lock);
> >    326                p->state = BR_STATE_FORWARDING;
> >    327                p->flags |= BR_MRP_AWARE;
> >    328                spin_unlock_bh(&br->lock);
> >    329                rcu_assign_pointer(mrp->s_port, p);
> >    330
> >    331                INIT_DELAYED_WORK(&mrp->test_work, br_mrp_test_work_expired);
> >  > 332                list_add_tail_rcu(&mrp->list, &br->mrp_list);
> >    333
> >    334                err = br_mrp_switchdev_add(br, mrp);
> >    335                if (err)
> >    336                        goto delete_mrp;
> >    337
> >    338                return 0;
> >    339
> >    340        delete_mrp:
> >    341                br_mrp_del_impl(br, mrp);
> >    342
> >    343                return err;
> >    344        }
> >    345
> >    346        /* Deletes the MRP instance from which the port is part of
> >    347         * note: called under rtnl_lock
> >    348         */
> >    349        void br_mrp_port_del(struct net_bridge *br, struct net_bridge_port *p)
> >    350        {
> >    351                struct br_mrp *mrp = br_mrp_find_port(br, p);
> >    352
> >    353                /* If the port is not part of a MRP instance just bail out */
> >    354                if (!mrp)
> >    355                        return;
> >    356
> >    357                br_mrp_del_impl(br, mrp);
> >    358        }
> >    359
> >    360        /* Deletes existing MRP instance based on ring_id
> >    361         * note: called under rtnl_lock
> >    362         */
> >    363        int br_mrp_del(struct net_bridge *br, struct br_mrp_instance *instance)
> >    364        {
> >    365                struct br_mrp *mrp = br_mrp_find_id(br, instance->ring_id);
> >    366
> >    367                if (!mrp)
> >    368                        return -EINVAL;
> >    369
> >    370                br_mrp_del_impl(br, mrp);
> >    371
> >    372                return 0;
> >    373        }
> >    374
> >    375        /* Deletes all MRP instances on the bridge
> >    376         * note: called under rtnl_lock
> >    377         */
> >    378        int br_mrp_clear(struct net_bridge *br)
> >    379        {
> >    380                struct br_mrp *mrp;
> >    381                struct br_mrp *tmp;
> >    382
> >  > 383                list_for_each_entry_safe(mrp, tmp, &br->mrp_list, list) {
> >    384                        br_mrp_del_impl(br, mrp);
> >    385                }
> >    386
> >    387                return 0;
> >    388        }
> >    389
> >
> > ---
> > 0-DAY CI Kernel Test Service, Intel Corporation
> > https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> >
> 

-- 
/Horatiu
