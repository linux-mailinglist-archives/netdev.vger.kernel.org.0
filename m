Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8978223CED6
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgHETHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:07:03 -0400
Received: from smtprelay0030.hostedemail.com ([216.40.44.30]:41064 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728142AbgHES6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 14:58:42 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave01.hostedemail.com (Postfix) with ESMTP id 22B971802030C;
        Wed,  5 Aug 2020 18:49:43 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 46CA2182CED5B;
        Wed,  5 Aug 2020 18:47:42 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:2:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1535:1593:1594:1605:1606:1730:1747:1777:1792:2393:2553:2559:2562:2734:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3870:3871:3872:3873:3874:4117:4321:4605:5007:6120:7903:7904:9030:9038:9121:10004:10848:11026:11232:11658:11914:12043:12294:12296:12297:12346:12438:12663:12740:12760:12895:13161:13229:13439:13972:14096:14097:14659:21063:21080:21095:21212:21433:21451:21627:21789:21819:30029:30054:30056:30060:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: plant09_051556b26fb1
X-Filterd-Recvd-Size: 6422
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf10.hostedemail.com (Postfix) with ESMTPA;
        Wed,  5 Aug 2020 18:47:41 +0000 (UTC)
Message-ID: <957f48692a2f0bc4df2d83068073c4822da30eef.camel@perches.com>
Subject: Re: [PATCH] MAINTAINERS: update phylink/sfp keyword matching
From:   Joe Perches <joe@perches.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Date:   Wed, 05 Aug 2020 11:47:38 -0700
In-Reply-To: <20200805182250.GX1551@shell.armlinux.org.uk>
References: <E1k3KUx-0000da-In@rmk-PC.armlinux.org.uk>
         <CAHk-=whbLwN9GEVVt=7eYhPYk0t0Wh1xeuNEDD+xmQxBFjAQJA@mail.gmail.com>
         <20200805182250.GX1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-08-05 at 19:22 +0100, Russell King - ARM Linux admin wrote:
> On Wed, Aug 05, 2020 at 11:11:28AM -0700, Linus Torvalds wrote:
> > On Wed, Aug 5, 2020 at 7:34 AM Russell King <rmk+kernel@armlinux.org.uk> wrote:
> > > Is this something you're willing to merge directly please?
> > 
> > Done.
> > 
> > That said:
> > 
> > > -K:     phylink
> > > +K:     phylink\.h|struct\s+phylink|\.phylink|>phylink_|phylink_(autoneg|clear|connect|create|destroy|disconnect|ethtool|helper|mac|mii|of|set|start|stop|test|validate)
> > 
> > That's a very awkward pattern. I wonder if there could be better ways
> > to express this (ie "only apply this pattern to these files" kind of
> > thing)
> 
> Yes, it's extremely awkward - I spent much of the morning with perl
> testing it out on the drivers/ subtree.

There are a lot of phylink_<foo> in the kernel.
Are those really the only uses you want to watch?

$ git grep -P -oh 'phylink_\w+'| sort | uniq -c

      4 phylink_add
      7 phylink_an_mode_str
      4 phylink_apply_manual_flow
      3 phylink_attach_phy
     26 phylink_autoneg_inband
      4 phylink_bringup_phy
      3 phylink_change_inband_advert
      6 phylink_clear
      4 phylink_complete
      2 phylink_complete_evt
    145 phylink_config
      3 phylink_connect
      8 phylink_connect_phy
     39 phylink_create
     10 phylink_dbg
      3 phylink_decode_c37_word
      2 phylink_decode_sgmii_word
     22 phylink_destroy
     11 phylink_disable_state
      1 phylink_disconnect
     23 phylink_disconnect_phy
      4 phylink_do_bit
      2 phylink_downs
     12 phylink_err
      7 phylink_ethtool_get_eee
      1 phylink_ethtool_get_eee_err
     10 phylink_ethtool_get_pauseparam
     11 phylink_ethtool_get_wol
     13 phylink_ethtool_ksettings_get
     13 phylink_ethtool_ksettings_set
     10 phylink_ethtool_nway_reset
      7 phylink_ethtool_set_eee
     10 phylink_ethtool_set_pauseparam
      9 phylink_ethtool_set_wol
      2 phylink_fixed_poll
      6 phylink_fixed_state
      4 phylink_gen_key
      5 phylink_get_eee_err
      6 phylink_get_fixed_state
      3 phylink_get_ksettings
      2 phylink_handler
     10 phylink_helper_basex_speed
      6 phylink_info
      4 phylink_init_eee
      3 phylink_is_empty_linkmode
      4 phylink_link_down
      2 phylink_link_handler
    168 phylink_link_state
      2 phylink_link_up
     11 phylink_mac_an_restart
     19 phylink_mac_change
     33 phylink_mac_config
      3 phylink_mac_initial_config
     33 phylink_mac_link_down
     18 phylink_mac_link_state
     28 phylink_mac_link_up
     36 phylink_mac_ops
      5 phylink_mac_pcs_an_restart
     10 phylink_mac_pcs_get_state
      4 phylink_major_config
      2 phylink_merge_link_mode
      4 phylink_mii_c22_pcs_an_restart
      4 phylink_mii_c22_pcs_config
      4 phylink_mii_c22_pcs_get_state
      5 phylink_mii_c22_pcs_set_advertisement
      3 phylink_mii_c45_pcs_get_state
      3 phylink_mii_emul_read
     13 phylink_mii_ioctl
      2 phylink_mii_read
      2 phylink_mii_write
      4 phylink_node
     19 phylink_of_phy_connect
     16 phylink_ops
      2 phylink_op_type
      2 phylink_parse_fixedlink
      2 phylink_parse_mode
      2 phylink_pause_to_str
     18 phylink_pcs
      6 phylink_pcs_ops
      5 phylink_phy_change
      2 phylink_phy_no_inband
      2 phylink_phy_read
      2 phylink_phy_write
      6 phylink_printk
      2 phylink_register
      2 phylink_register_sfp
      2 phylink_resolve
      2 phylink_resolve_flow
      8 phylink_run_resolve
      3 phylink_run_resolve_and_disable
    406 phylink_set
      5 phylink_set_pcs
     23 phylink_set_port_modes
      2 phylink_setup
      2 phylink_sfp_attach
      4 phylink_sfp_config
      2 phylink_sfp_connect_phy
      2 phylink_sfp_detach
      2 phylink_sfp_disconnect_phy
      2 phylink_sfp_link_down
      2 phylink_sfp_link_up
      2 phylink_sfp_module_insert
      2 phylink_sfp_module_start
      2 phylink_sfp_module_stop
     11 phylink_speed_down
      7 phylink_speed_up
     21 phylink_start
     23 phylink_stop
     31 phylink_test
      5 phylink_to_dpaa2_mac
      7 phylink_to_port
      2 phylink_ups
    125 phylink_validate
      4 phylink_warn
      7 phylink_zero

> > Isn't the 'F' pattern already complete enough that maybe the K pattern
> > isn't even worth it?
> 
> Unfortunately not; I used not to have a K: line, which presented the
> problem that we had users of phylink added to the kernel that were not
> being reviewed.  So, the suggestion was to add a K: line.
> 
> However, I'm now being spammed by syzbot (I've received multiple emails
> about the same problem) because, rather than MAINTAINERS being applied
> to just patches, it is now being applied to entire source files.  This
> means that the previous "K: phylink" entry matches not just on patches
> (which can be easily ignored) but entire files, such as
> net/bluetooth/hci_event.c which happens to contain "phylink" in a
> function name.
> 
> So, when syzbot identifies there is a problem in
> net/bluetooth/hci_event.c, it sends me a report, despite it having
> no relevance for me.

Maybe instead syzbot could ignore K: lines
by adding --nokeywords to its command line
for get_maintainer.pl.


