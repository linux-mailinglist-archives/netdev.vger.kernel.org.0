Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40CD41916C8
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 17:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbgCXQrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 12:47:09 -0400
Received: from smtprelay0192.hostedemail.com ([216.40.44.192]:53410 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727065AbgCXQrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 12:47:08 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 3277FA89DE;
        Tue, 24 Mar 2020 16:47:07 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1535:1543:1593:1594:1605:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2828:2859:2892:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4605:5007:6117:6691:7688:7875:7903:7904:8531:8957:9025:9121:10004:10400:10471:10848:11026:11232:11658:11914:12043:12295:12296:12297:12438:12740:12760:12895:13255:13439:14096:14097:14180:14181:14659:14721:21060:21080:21627:21740:30054:30055:30060:30075:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: seat22_3ddc47581f618
X-Filterd-Recvd-Size: 5278
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Tue, 24 Mar 2020 16:47:04 +0000 (UTC)
Message-ID: <8c1916c8a0f769f390a53aeba1ffd6043e12611a.camel@perches.com>
Subject: Re: [PATCH v1 1/2] Bluetooth: btusb: Indicate Microsoft vendor
 extension for Intel 9460/9560 and 9160/9260
From:   Joe Perches <joe@perches.com>
To:     Alain Michaud <alainmichaud@google.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Date:   Tue, 24 Mar 2020 09:45:15 -0700
In-Reply-To: <CALWDO_U8hruyjvZmN5P3kYz-awhD8t7yNbX9K0uXd5OdDejdMA@mail.gmail.com>
References: <20200323072824.254495-1-mcchou@chromium.org>
         <20200323002820.v1.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
         <04021BE3-63F7-4B19-9F0E-145785594E8C@holtmann.org>
         <421d27670f2736c88e8c0693e3ff7c0dcfceb40b.camel@perches.com>
         <57C56801-7F3B-478A-83E9-1D2376C60666@holtmann.org>
         <03547be94c4944ca672c7aef2dd38b0fb1eedc84.camel@perches.com>
         <CALWDO_U5Cnt3_Ss2QQNhtuKS_8qq7oyNH4d97J68pmbmQMe=3w@mail.gmail.com>
         <b7b6e52eccca921ccea16b7679789eb3e2115871.camel@perches.com>
         <CALWDO_U8hruyjvZmN5P3kYz-awhD8t7yNbX9K0uXd5OdDejdMA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-03-24 at 11:24 -0400, Alain Michaud wrote:
> On Tue, Mar 24, 2020 at 11:19 AM Joe Perches <joe@perches.com> wrote:
> > On Tue, 2020-03-24 at 11:10 -0400, Alain Michaud wrote:
> > > On Mon, Mar 23, 2020 at 4:11 PM Joe Perches <joe@perches.com> wrote:
> > > > On Mon, 2020-03-23 at 19:48 +0100, Marcel Holtmann wrote:
> > > > > Hi Joe,
> > > > 
> > > > Hello Marcel.
> > > > 
> > > > > > > > This adds a bit mask of driver_info for Microsoft vendor extension and
> > > > > > > > indicates the support for Intel 9460/9560 and 9160/9260. See
> > > > > > > > https://docs.microsoft.com/en-us/windows-hardware/drivers/bluetooth/
> > > > > > > > microsoft-defined-bluetooth-hci-commands-and-events for more information
> > > > > > > > about the extension. This was verified with Intel ThunderPeak BT controller
> > > > > > > > where msft_vnd_ext_opcode is 0xFC1E.
> > > > > > []
> > > > > > > > diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> > > > > > []
> > > > > > > > @@ -315,6 +315,10 @@ struct hci_dev {
> > > > > > > >         __u8            ssp_debug_mode;
> > > > > > > >         __u8            hw_error_code;
> > > > > > > >         __u32           clock;
> > > > > > > > +       __u16           msft_vnd_ext_opcode;
> > > > > > > > +       __u64           msft_vnd_ext_features;
> > > > > > > > +       __u8            msft_vnd_ext_evt_prefix_len;
> > > > > > > > +       void            *msft_vnd_ext_evt_prefix;
> > > > > > 
> > > > > > msft is just another vendor.
> > > > > > 
> > > > > > If there are to be vendor extensions, this should
> > > > > > likely use a blank line above and below and not
> > > > > > be prefixed with msft_
> > > > > 
> > > > > there are other vendors, but all of them are different. So this needs to be prefixed with msft_ actually. But I agree that having empty lines above and below makes it more readable.
> > > > 
> > > > So struct hci_dev should become a clutter
> > > > of random vendor extensions?
> > > > 
> > > > Perhaps there should instead be something like
> > > > an array of char at the end of the struct and
> > > > various vendor specific extensions could be
> > > > overlaid on that array or just add a void *
> > > > to whatever info that vendors require.
> > > I don't particularly like trailing buffers, but I agree we could
> > > possibly organize this a little better by with a struct.  something
> > > like:
> > > 
> > > struct msft_vnd_ext {
> > >     bool       f       supported; // <-- Clearly calls out if the
> > > extension is supported.
> > >     __u16           msft_vnd_ext_opcode; // <-- Note that this also
> > > needs to be provided by the driver.  I don't recommend we have this
> > > read from the hardware since we just cause an extra redirection that
> > > isn't necessary.  Ideally, this should come from the usb_table const.
> > >     __u64           msft_vnd_ext_features;
> > >     __u8             msft_vnd_ext_evt_prefix_len;
> > >     void             *msft_vnd_ext_evt_prefix;
> > > };
> > > 
> > > And then simply add the struct msft_vnd_ext (and any others) to hci_dev.
> > 
> > Or use an anonymous union
> That would also work, but would need to be an array of unions, perhaps
> following your original idea to have them be in a trailing array of
> unions since a controller may support more than one extension.  This
> might be going overboard :)

True.

Especially true if the controller supports multiple
concurrent extensions.


