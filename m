Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3793828B43F
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 13:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388362AbgJLL7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 07:59:32 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:20803 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388209AbgJLL7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 07:59:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602503971; x=1634039971;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZQpmQnv2bppFu4iHMRCySxuz/8he+l1cLdbBjy/BBIY=;
  b=fvELu6OEsGJjxHcCCAEwFgHEPILx0PKKdn3V7dk9m9N7ZV4UO/JxmmWd
   vXd9+aZDyvmqZe2DDA4Q7hNQEkRXdA/PQsHbrhR9DTNkijVTSesxPc1Ec
   7DZtVwCWdaM/eTdKwn3F9m2o5uD0/+iQjqwL+PzwfO/+BaIrKClp1Ted5
   orG/ID/iKw64OePiEg1nXbpaIEjaWZdW9TTqycXFEoO1C8FAxEQ6SilEh
   f6CCNPvHWSY73Qgpu4B1vmf0mmBKaiEnxK++oV0tn/J6CZOZe4rIxh+iw
   fxEWPV4jzl/QW9lXyEuZKq4Dc298kH82vVgmGOx2N/AJGMiT0vvZL0Yua
   w==;
IronPort-SDR: Jdg3nGDX07cJHTWCaym1uROXKNQ3JlLnV9AoHgvuptAn59cYAdgrBmapjM0L02T6Wvu0dChVXc
 fs2sZg1bV6xESc2MEw6NDcvXOjpO+uu+ZI+0vmt0ENV/XAI8KKOiQifuWOs06vdPj7F3Ay8jUk
 Y9Nb4UVdoMOBCw6ac/S+bTwoCmURBRa3GtsmsT2qAbTd3xGZr3Ld6Mkcp3AriMbOOghmOHRfiV
 zcJJ8aW6x7xUL/z0n7S5a07dfAaxdVAqLlAjVJvvmO5wUL86BJ1KAP+br/0JDA22AVfv0UMgvw
 6Vg=
X-IronPort-AV: E=Sophos;i="5.77,366,1596524400"; 
   d="scan'208";a="89891813"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Oct 2020 04:59:31 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 12 Oct 2020 04:59:30 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 12 Oct 2020 04:59:30 -0700
Date:   Mon, 12 Oct 2020 11:57:44 +0000
From:   "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v4 01/10] net: bridge: extend the process of
 special frames
Message-ID: <20201012115744.56mjeuoe7nlonjxt@soft-test08>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
 <20201009143530.2438738-2-henrik.bjoernlund@microchip.com>
 <3fc314a2074001f7b39bada2c50529eb2aefd077.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <3fc314a2074001f7b39bada2c50529eb2aefd077.camel@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review. Comments below.

The 10/12/2020 09:12, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Fri, 2020-10-09 at 14:35 +0000, Henrik Bjoernlund wrote:
> > This patch extends the processing of frames in the bridge. Currently MRP
> > frames needs special processing and the current implementation doesn't
> > allow a nice way to process different frame types. Therefore try to
> > improve this by adding a list that contains frame types that need
> > special processing. This list is iterated for each input frame and if
> > there is a match based on frame type then these functions will be called
> > and decide what to do with the frame. It can process the frame then the
> > bridge doesn't need to do anything or don't process so then the bridge
> > will do normal forwarding.
> >
> > Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
> > Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
> > ---
> >  net/bridge/br_device.c  |  1 +
> >  net/bridge/br_input.c   | 33 ++++++++++++++++++++++++++++++++-
> >  net/bridge/br_mrp.c     | 19 +++++++++++++++----
> >  net/bridge/br_private.h | 18 ++++++++++++------
> >  4 files changed, 60 insertions(+), 11 deletions(-)
> >
> [snip]
> > diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> > index 345118e35c42..3e62ce2ef8a5 100644
> > --- a/net/bridge/br_private.h
> > +++ b/net/bridge/br_private.h
> > @@ -480,6 +480,8 @@ struct net_bridge {
> >  #endif
> >       struct hlist_head               fdb_list;
> >
> > +     struct hlist_head               frame_type_list;
> 
> Since there will be a v5, I'd suggest to move this struct member in the first
> cache line as it will be always used in the bridge fast-path for all cases.
> In order to make room for it there you can move port_list after fdb_hash_tbl and
> add this in its place, port_list is currently used only when flooding and soon
> I'll even change that.
> 
> Thanks,
>  Nik
>
I will do change as requested.

> > +
> >  #if IS_ENABLED(CONFIG_BRIDGE_MRP)
> >       struct list_head                mrp_list;
> >  #endif
> > @@ -755,6 +757,16 @@ int nbp_backup_change(struct net_bridge_port *p, struct net_device *backup_dev);
> >  int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb);
> >  rx_handler_func_t *br_get_rx_handler(const struct net_device *dev);
> >
> > +struct br_frame_type {
> > +     __be16                  type;
> > +     int                     (*frame_handler)(struct net_bridge_port *port,
> > +                                              struct sk_buff *skb);
> > +     struct hlist_node       list;
> > +};
> > +
> > +void br_add_frame(struct net_bridge *br, struct br_frame_type *ft);
> > +void br_del_frame(struct net_bridge *br, struct br_frame_type *ft);
> > +
> >  static inline bool br_rx_handler_check_rcu(const struct net_device *dev)
> >  {
> >       return rcu_dereference(dev->rx_handler) == br_get_rx_handler(dev);
> > @@ -1417,7 +1429,6 @@ extern int (*br_fdb_test_addr_hook)(struct net_device *dev, unsigned char *addr)
> >  #if IS_ENABLED(CONFIG_BRIDGE_MRP)
> >  int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
> >                struct nlattr *attr, int cmd, struct netlink_ext_ack *extack);
> > -int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb);
> >  bool br_mrp_enabled(struct net_bridge *br);
> >  void br_mrp_port_del(struct net_bridge *br, struct net_bridge_port *p);
> >  int br_mrp_fill_info(struct sk_buff *skb, struct net_bridge *br);
> > @@ -1429,11 +1440,6 @@ static inline int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
> >       return -EOPNOTSUPP;
> >  }
> >
> > -static inline int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb)
> > -{
> > -     return 0;
> > -}
> > -
> >  static inline bool br_mrp_enabled(struct net_bridge *br)
> >  {
> >       return false;
> 

-- 
/Henrik
