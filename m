Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A975C176
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 18:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbfGAQxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 12:53:52 -0400
Received: from linuxlounge.net ([88.198.164.195]:54328 "EHLO linuxlounge.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727563AbfGAQxw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 12:53:52 -0400
To:     nikolay@cumulusnetworks.com, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@cumulusnetworks.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxlounge.net;
        s=mail; t=1562000026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp:autocrypt:autocrypt;
        bh=XdVbDsduQcNuVif0PodgUuj+obZj2fc0FOXXZhKJjcE=;
        b=hHUKfH3umu/ly/W3NGsw4nU/i5drkTBFO4JfB2p62Um1JiV/IxduWCEn4WVBxKTh6ORn4z
        FLC3lQCLebXbPhYkJ4jnrH1lCNEH0HzdPi956kyrBsFTCvBPwnR0v4SUUgtJjTNfPD+BxX
        NBxF24dLfZcHfCGUQXf5pvLeHzkdVYg=
Cc:     netdev@vger.kernel.org
References: <41ac3aa3-cbf7-1b7b-d847-1fb308334931@linuxlounge.net>
 <E0170D52-C181-4F0F-B5F8-F1801C2A8F5A@cumulusnetworks.com>
From:   Martin Weinelt <martin@linuxlounge.net>
Openpgp: preference=signencrypt
Autocrypt: addr=martin@linuxlounge.net; prefer-encrypt=mutual; keydata=
 mQENBEv1rfkBCADFlzzmynjVg8L5ok/ef2Jxz8D96PtEAP//3U612b4QbHXzHC6+C2qmFEL6
 5kG1U1a7PPsEaS/A6K9AUpDhT7y6tX1IxAkSkdIEmIgWC5Pu2df4+xyWXarJfqlBeJ82biot
 /qETntfo01wm0AtqfJzDh/BkUpQw0dbWBSnAF6LytoNEggIGnUGmzvCidrEEsTCO6YlHfKIH
 cpz7iwgVZi4Ajtsky8v8P8P7sX0se/ce1L+qX/qN7TnXpcdVSfZpMnArTPkrmlJT4inBLhKx
 UeDMQmHe+BQvATa21fhcqi3BPIMwIalzLqVSIvRmKY6oYdCbKLM2TZ5HmyJepusl2Gi3ABEB
 AAG0J01hcnRpbiBXZWluZWx0IDxtYXJ0aW5AbGludXhsb3VuZ2UubmV0PokBWAQTAQoAQgIb
 IwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4ACGQEWIQTu0BYCvL0ZbDi8mh+9SqBSj2PxfgUC
 W/RuFQUJEd/znAAKCRC9SqBSj2PxfpfDCACDx6BYz6cGMiweQ96lXi+ihx7RBaXsfPp2KxUo
 eHilrDPqknq62XJibCyNCJiYGNb+RUS5WfDUAqxdl4HuNxQMC/sYlbP4b7p9Y1Q9QiTP4f6M
 8+Uvpicin+9H/lye5hS/Gp2KUiVI/gzqW68WqMhARUYw00lVSlJHy+xHEGVuQ0vmeopjU81R
 0si4+HhMX2HtILTxoUcvm67AFKidTHYMJKwNyMHiLLvSK6wwiy+MXaiqrMVTwSIOQhLgLVcJ
 33GNJ2Emkgkhs6xcaiN8xTjxDmiU7b5lXW4JiAsd1rbKINajcA7DVlZ/evGfpN9FczyZ4W6F
 Rf21CxSwtqv2SQHBuQENBEv1rfkBCADJX6bbb5LsXjdxDeFgqo+XRUvW0bzuS3SYNo0fuktM
 5WYMCX7TzoF556QU8A7C7bDUkT4THBUzfaA8ZKIuneYW2WN1OI0zRMpmWVeZcUQpXncWWKCg
 LBNYtk9CCukPE0OpDFnbR+GhGd1KF/YyemYnzwW2f1NOtHjwT3iuYnzzZNlWoZAR2CRSD02B
 YU87Mr2CMXrgG/pdRiaD+yBUG9RxCUkIWJQ5dcvgrsg81vOTj6OCp/47Xk/457O0pUFtySKS
 jZkZN6S7YXl/t+8C9g7o3N58y/X95VVEw/G3KegUR2SwcLdok4HaxgOy5YHiC+qtGNZmDiQn
 NXN7WIN/oof7ABEBAAGJATwEGAEKACYCGwwWIQTu0BYCvL0ZbDi8mh+9SqBSj2PxfgUCW/Ru
 GAUJEd/znwAKCRC9SqBSj2PxfpzMCACH55MVYTVykq+CWj1WMKHex9iFg7M9DkWQCF/Zl+0v
 QmyRMEMZnFW8GdX/Qgd4QbZMUTOGevGxFPTe4p0PPKqKEDXXXxTTHQETE/Hl0jJvyu+MgTxG
 E9/KrWmsmQC7ogTFCHf0vvVY3UjWChOqRE19Buk4eYpMbuU1dYefLNcD15o4hGDhohYn3SJr
 q9eaoO6rpnNIrNodeG+1vZYG1B2jpEdU4v354ziGcibt5835IONuVdvuZMFQJ4Pn2yyC+qJe
 ekXwZ5f4JEt0lWD9YUxB2cU+xM9sbDcQ2b6+ypVFzMyfU0Q6LzYugAqajZ10gWKmeyjisgyq
 sv5UJTKaOB/t
Subject: Re: Use-after-free in br_multicast_rcv
Message-ID: <21ab085f-0f7f-88bc-b661-af74dd9eeea2@linuxlounge.net>
Date:   Mon, 1 Jul 2019 18:53:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
In-Reply-To: <E0170D52-C181-4F0F-B5F8-F1801C2A8F5A@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nik,

more info below.

On 6/29/19 3:11 PM, nikolay@cumulusnetworks.com wrote:
> On 29 June 2019 14:54:44 EEST, Martin Weinelt <martin@linuxlounge.net> wrote:
>> Hello,
>>
>> we've recently been experiencing memory leaks on our Linux-based
>> routers,
>> at least as far back as v4.19.16.
>>
>> After rebuilding with KASAN it found a use-after-free in 
>> br_multicast_rcv which I could reproduce on v5.2.0-rc6. 
>>
>> Please find the KASAN report below, I'm anot sure what else to provide
>> so
>> feel free to ask.
>>
>> Best,
>>  Martin
>>
>>
> 
> Hi Martin, 
> I'll look into this, are there any specific steps to reproduce it? 
> 
> Thanks, 
>    Nik
> 
 
Each server is a KVM Guest and has 18 bridges with the same master/slave
relationships:

  bridge -> batman-adv -> {l2 tunnel, virtio device}

Linus Lüssing from the batman-adv asked me to apply this patch to help
debugging.

v5.2-rc6-170-g728254541ebc with this patch yielded the following KASAN 
report, not sure if the additional information at the end is a result of
the added patch though.

Best,
  Martin

From 47a04e977311a0c45f26905588f563b55239da7f Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
Date: Sat, 29 Jun 2019 20:24:23 +0200
Subject: [PATCH] bridge: DEBUG: ipv6_addr_is_ll_all_nodes() wrappers for impr.
 call traces

---
 net/bridge/br_multicast.c | 70 +++++++++++++++++++++++++++++++++++----
 1 file changed, 63 insertions(+), 7 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index de22c8fbbb15..224a43318955 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -57,6 +57,42 @@ static void br_ip6_multicast_leave_group(struct net_bridge *br,
 					 struct net_bridge_port *port,
 					 const struct in6_addr *group,
 					 __u16 vid, const unsigned char *src);
+
+static noinline void br_ip6_multicast_leave_group_mld2report(
+					 struct net_bridge *br,
+					 struct net_bridge_port *port,
+					 const struct in6_addr *group,
+					 __u16 vid,
+					 const unsigned char *src)
+{
+	br_ip6_multicast_leave_group(br, port, group, vid, src);
+}
+
+static noinline void br_ip6_multicast_leave_group_ipv6rcv(
+					 struct net_bridge *br,
+					 struct net_bridge_port *port,
+					 const struct in6_addr *group,
+					 __u16 vid,
+					 const unsigned char *src)
+{
+	br_ip6_multicast_leave_group(br, port, group, vid, src);
+}
+
+
+static noinline bool ipv6_addr_is_ll_all_nodes_addgroup(const struct in6_addr *addr)
+{
+	return ipv6_addr_is_ll_all_nodes(addr);
+}
+
+static noinline bool ipv6_addr_is_ll_all_nodes_leavegroup(const struct in6_addr *addr)
+{
+	return ipv6_addr_is_ll_all_nodes(addr);
+}
+
+static noinline bool ipv6_addr_is_ll_all_nodes_mcastrcv(const struct in6_addr *addr)
+{
+	return ipv6_addr_is_ll_all_nodes(addr);
+}
 #endif
 
 static struct net_bridge_mdb_entry *br_mdb_ip_get_rcu(struct net_bridge *br,
@@ -595,7 +631,7 @@ static int br_ip6_multicast_add_group(struct net_bridge *br,
 {
 	struct br_ip br_group;
 
-	if (ipv6_addr_is_ll_all_nodes(group))
+	if (ipv6_addr_is_ll_all_nodes_addgroup(group))
 		return 0;
 
 	memset(&br_group, 0, sizeof(br_group));
@@ -605,6 +641,26 @@ static int br_ip6_multicast_add_group(struct net_bridge *br,
 
 	return br_multicast_add_group(br, port, &br_group, src);
 }
+
+static noinline int br_ip6_multicast_add_group_mld2report(
+				      struct net_bridge *br,
+				      struct net_bridge_port *port,
+				      const struct in6_addr *group,
+				      __u16 vid,
+				      const unsigned char *src)
+{
+	return br_ip6_multicast_add_group(br, port, group, vid, src);
+}
+
+static noinline int br_ip6_multicast_add_group_ipv6rcv(
+				      struct net_bridge *br,
+				      struct net_bridge_port *port,
+				      const struct in6_addr *group,
+				      __u16 vid,
+				      const unsigned char *src)
+{
+	return br_ip6_multicast_add_group(br, port, group, vid, src);
+}
 #endif
 
 static void br_multicast_router_expired(struct timer_list *t)
@@ -1022,10 +1078,10 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 		if ((grec->grec_type == MLD2_CHANGE_TO_INCLUDE ||
 		     grec->grec_type == MLD2_MODE_IS_INCLUDE) &&
 		    ntohs(*nsrcs) == 0) {
-			br_ip6_multicast_leave_group(br, port, &grec->grec_mca,
+			br_ip6_multicast_leave_group_mld2report(br, port, &grec->grec_mca,
 						     vid, src);
 		} else {
-			err = br_ip6_multicast_add_group(br, port,
+			err = br_ip6_multicast_add_group_mld2report(br, port,
 							 &grec->grec_mca, vid,
 							 src);
 			if (err)
@@ -1494,7 +1550,7 @@ static void br_ip6_multicast_leave_group(struct net_bridge *br,
 	struct br_ip br_group;
 	struct bridge_mcast_own_query *own_query;
 
-	if (ipv6_addr_is_ll_all_nodes(group))
+	if (ipv6_addr_is_ll_all_nodes_leavegroup(group))
 		return;
 
 	own_query = port ? &port->ip6_own_query : &br->ip6_own_query;
@@ -1658,7 +1714,7 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
 	err = ipv6_mc_check_mld(skb);
 
 	if (err == -ENOMSG) {
-		if (!ipv6_addr_is_ll_all_nodes(&ipv6_hdr(skb)->daddr))
+		if (!ipv6_addr_is_ll_all_nodes_mcastrcv(&ipv6_hdr(skb)->daddr))
 			BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
 
 		if (ipv6_addr_is_all_snoopers(&ipv6_hdr(skb)->daddr)) {
@@ -1683,7 +1739,7 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
 	case ICMPV6_MGM_REPORT:
 		src = eth_hdr(skb)->h_source;
 		BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
-		err = br_ip6_multicast_add_group(br, port, &mld->mld_mca, vid,
+		err = br_ip6_multicast_add_group_ipv6rcv(br, port, &mld->mld_mca, vid,
 						 src);
 		break;
 	case ICMPV6_MLD2_REPORT:
@@ -1694,7 +1750,7 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
 		break;
 	case ICMPV6_MGM_REDUCTION:
 		src = eth_hdr(skb)->h_source;
-		br_ip6_multicast_leave_group(br, port, &mld->mld_mca, vid, src);
+		br_ip6_multicast_leave_group_ipv6rcv(br, port, &mld->mld_mca, vid, src);
 		break;
 	}
 
-- 
2.20.1


[  409.353973] ==================================================================                                                                                                                                     
[  409.356970] BUG: KASAN: out-of-bounds in br_multicast_rcv+0x36e9/0x4080 [bridge]  
[  409.359360] Read of size 2 at addr ffff888046e980b8 by task swapper/2/0      
[  409.361668]                                                                                                                                                                                                                                                                         
[  409.362215] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G           OE     5.2.0-rc6+ #1        
[  409.364503] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
[  409.367006] Call Trace:                                                         
[  409.367699]  <IRQ>                                                                                                                                                                                                                                                                  
[  409.368283]  dump_stack+0x71/0xab                                                                                                                                                                                  
[  409.369175]  print_address_description+0x6a/0x280                                  
[  409.370350]  ? br_multicast_rcv+0x36e9/0x4080 [bridge]                                     
[  409.371752]  __kasan_report+0x152/0x1aa                                                                                                                                                                                                                                             
[  409.372703]  ? br_multicast_rcv+0x36e9/0x4080 [bridge]                       
[  409.373950]  ? br_multicast_rcv+0x36e9/0x4080 [bridge]                       
[  409.375308]  kasan_report+0xe/0x20                                           
[  409.376149]  br_multicast_rcv+0x36e9/0x4080 [bridge]                                                                                                                                                                                                                                
[  409.377460]  ? br_multicast_disable_port+0x150/0x150 [bridge]
[  409.379079]  ? kvm_clock_get_cycles+0xd/0x10                          
[  409.380291]  ? __kasan_kmalloc.constprop.6+0xa6/0xf0             
[  409.381693]  ? netif_receive_skb_internal+0x84/0x1a0                                                                                                                                                                                                                                
[  409.383075]  ? __netif_receive_skb+0x1b0/0x1b0      
[  409.384355]  ? br_fdb_update+0x10e/0x6e0 [bridge]                   
[  409.385700]  ? br_handle_frame_finish+0x3c6/0x11d0 [bridge]        
[  409.387283]  br_handle_frame_finish+0x3c6/0x11d0 [bridge]                                                                                                                                                                                                                           
[  409.388807]  ? br_pass_frame_up+0x3a0/0x3a0 [bridge]                   
[  409.390200]  ? virtnet_probe+0x1c80/0x1c80 [virtio_net]               
[  409.391685]  br_handle_frame+0x731/0xd90 [bridge]                
[  409.393017]  ? br_handle_frame_finish+0x11d0/0x11d0 [bridge]                                                                                                                                                                                                                        
[  409.394591]  ? __update_load_avg_se+0x592/0xa70                                   
[  409.395862]  ? __update_load_avg_se+0x592/0xa70                                                                
[  409.397065]  __netif_receive_skb_core+0xced/0x2d70                           
[  409.398208]  ? napi_complete_done+0x10/0x360                                                                                                                                                                                                                                        
[  409.399249]  ? virtqueue_get_buf_ctx+0x271/0x1130 [virtio_ring]                     
[  409.400632]  ? do_xdp_generic+0x20/0x20                                      
[  409.401565]  ? virtqueue_napi_complete+0x39/0x70 [virtio_net]
[  409.404824]  ? virtnet_poll+0x94d/0xc78 [virtio_net]       
[  409.407552]  ? receive_buf+0x5120/0x5120 [virtio_net]                                                                                                                                                              
[  409.410255]  ? __netif_receive_skb_one_core+0x97/0x1d0                            
[  409.413023]  ? account_entity_enqueue+0x340/0x4c0                             
[  409.415639]  __netif_receive_skb_one_core+0x97/0x1d0                                                                                                                                                               
[  409.418346]  ? __netif_receive_skb_core+0x2d70/0x2d70                             
[  409.421143]  ? _raw_write_trylock+0x100/0x100                                 
[  409.423775]  process_backlog+0x19c/0x650                                      
[  409.426383]  net_rx_action+0x71e/0xbc0                                                                                                                                                                             
[  409.428960]  ? napi_complete_done+0x360/0x360                                     
[  409.431693]  ? handle_irq_event_percpu+0xeb/0x140                            
[  409.434705]  ? _raw_spin_lock+0x7a/0xd0                                      
[  409.439881]  ? _raw_write_trylock+0x100/0x100                                
[  409.444967]  __do_softirq+0x1db/0x5f9                                        
[  409.447999]  irq_exit+0x123/0x150                                            
[  409.451116]  do_IRQ+0x71/0x160                                    
[  409.453709]  common_interrupt+0xf/0xf                
[  409.456384]  </IRQ>                                                                                            
[  409.458708] RIP: 0010:native_safe_halt+0xe/0x10                                                                                                                                                                    
[  409.461587] Code: 09 f9 fe 48 8b 04 24 e9 12 ff ff ff e9 07 00 00 00 0f 00 2d d4 60 52 00 f4 c3 66 90 e9 07 00 00 00 0f 00 2d c4 60 52 00 fb f4 <c3> 90 66 66 66 66 90 41 56 41 55 41 54 55 53 e8 7e 05 ba fe 65 44
[  409.469813] RSP: 0018:ffff88805056fd98 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffd3  
[  409.474002] RAX: ffffffff97f1ad00 RBX: 0000000000000002 RCX: ffffffff96abbbd6
[  409.477775] RDX: 1ffff1100a0a63d0 RSI: 0000000000000004 RDI: ffff8880510b3f38
[  409.481830] RBP: ffffed100a0a63d0 R08: ffffed100a2167e8 R09: ffffed100a2167e7                                  
[  409.486087] R10: ffff8880510b3f3b R11: ffffed100a2167e8 R12: ffffffff98e60480                                                                                                                                      
[  409.490757] R13: 0000000000000002 R14: 0000000000000000 R15: ffff888050531e80       
[  409.495061]  ? ldsem_down_write+0x590/0x590                                         
[  409.499258]  ? rcu_idle_enter+0x106/0x150                                    
[  409.502755]  ? tsc_verify_tsc_adjust+0x96/0x2a0                               
[  409.506287]  default_idle+0x1f/0x280                                          
[  409.509105]  do_idle+0x2d8/0x3e0                                              
[  409.511741]  ? arch_cpu_idle_exit+0x40/0x40                                                                    
[  409.514588]  cpu_startup_entry+0x19/0x20                                      
[  409.517355]  start_secondary+0x316/0x3f0                                            
[  409.520051]  ? set_cpu_sibling_map+0x19c0/0x19c0                                    
[  409.522871]  secondary_startup_64+0xa4/0xb0                                   
[  409.525603]                                                                   
[  409.527708] Allocated by task 0:                        
[  409.530201]  save_stack+0x19/0x70                                             
[  409.532757]  __kasan_kmalloc.constprop.6+0xa6/0xf0                            
[  409.535660]  __kmalloc_node_track_caller+0xe3/0x2c0                           
[  409.538641]  __kmalloc_reserve.isra.45+0x2e/0xb0     
[  409.541426]  pskb_expand_head+0x118/0xcb0                                     
[  409.544107]  __pskb_pull_tail+0xb9/0x1980                                     
[  409.546749]  validate_xmit_skb+0x556/0xab0                                    
[  409.549387]  __dev_queue_xmit+0x11bc/0x2b70                            
[  409.552145]  ip_finish_output2+0xa7e/0x18c0                    
[  409.554817]  ip_output+0x1a1/0x2b0                          
[  409.557335]  ip_forward+0xe39/0x1a20                              
[  409.559875]  ip_rcv+0xb3/0x180                    
[  409.562271]  __netif_receive_skb_one_core+0x145/0x1d0                                                          
[  409.565068]  netif_receive_skb_internal+0x84/0x1a0
[  409.567841]  napi_gro_flush+0x1d7/0x380                                             
[  409.570492]  napi_complete_done+0x172/0x360                                         
[  409.573147]  virtqueue_napi_complete+0x2a/0x70 [virtio_net]
[  409.576154]  virtnet_poll+0x94d/0xc78 [virtio_net]   
[  409.578963]  net_rx_action+0x71e/0xbc0            
[  409.581482]  __do_softirq+0x1db/0x5f9                                         
[  409.584023]                                                                   
[  409.586052] Freed by task 12968:                                              
[  409.588489]  save_stack+0x19/0x70                                 
[  409.591065]  __kasan_slab_free+0x122/0x180                                    
[  409.593775]  kfree+0xa6/0x1f0                                                                                  
[  409.596228]  consume_skb+0x69/0x160                                           
[  409.598803]  tun_do_read+0x53c/0x1b30 [tun]                                         
[  409.601563]  tun_chr_read_iter+0x14a/0x2d0 [tun]                                    
[  409.604477]  new_sync_read+0x3e3/0x6b0                     
[  409.606956]  vfs_read+0xe9/0x2d0
[  409.609283]  ksys_read+0xe8/0x1c0                 
[  409.611566]  do_syscall_64+0xa0/0x2c0                                         
[  409.613927]  entry_SYSCALL_64_after_hwframe+0x44/0xa9                         
[  409.616671]                                                                   
[  409.618573] The buggy address belongs to the object at ffff888046e98000
[  409.618573]  which belongs to the cache kmalloc-2k of size 2048               
[  409.624699] The buggy address is located 184 bytes inside of                  
[  409.624699]  2048-byte region [ffff888046e98000, ffff888046e98800)            
[  409.630602] The buggy address belongs to the page:      
[  409.633445] page:ffffea00011ba600 refcount:1 mapcount:0 mapping:ffff888050c02a80 index:0x0 compound_mapcount: 0
[  409.638069] flags: 0xffffc000010200(slab|head)
[  409.641048] raw: 00ffffc000010200 dead000000000100 dead000000000200 ffff888050c02a80
[  409.644876] raw: 0000000000000000 00000000000f000f 00000001ffffffff 0000000000000000
[  409.648486] page dumped because: kasan: bad access detected
[  409.651569]
[  409.653718] Memory state around the buggy address:
[  409.656635]  ffff888046e97f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  409.660222]  ffff888046e98000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  409.663775] >ffff888046e98080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  409.667332]                                         ^
[  409.670247]  ffff888046e98100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  409.673815]  ffff888046e98180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  409.677391] ==================================================================
[  409.681002] Disabling lock debugging due to kernel taint
