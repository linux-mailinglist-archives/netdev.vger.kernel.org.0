Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0436E1913EE
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 16:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgCXPLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 11:11:06 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39036 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbgCXPLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 11:11:06 -0400
Received: by mail-lj1-f193.google.com with SMTP id i20so6896183ljn.6
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 08:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kyFduZ6VwjzQIiJQ/lBuEzWDfMDYvttrQIwiQL9qENU=;
        b=lV8x446tzSYygFYppGaw9+2BQMof1D1ksnvF9IK7P+8mx5vNtsOTdVM0v5TOcGdG8c
         Uq/7Q2y3gt/SJglq0t0+tp+EzPFRMtEiihvrZGEacloF6tkUjAPyuAdHfPwlfchVODTM
         EAg9baoKJ4IAG1KVVOb8L5IYhjdwl4ziCTLTBv+d2XvrOK76ub1eNBh24xv4N4j+nHj+
         sr8DHzmtdyy5bC97jyU+bv5+Va3RnF4ILk0I5qJ38KnPf9wKY+9VpiXPVm3kzoi1/dd5
         NkptJKCJSWlkoNTqNamItZDIi9AC3tW3wh+vpWkBuMGne7WWacZxIDntgraqioVPopWc
         dmkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kyFduZ6VwjzQIiJQ/lBuEzWDfMDYvttrQIwiQL9qENU=;
        b=liboyKrmyUQ8mOuGj5H4pHHBdPmL2KHpcNsInMOfDox568HIRRbOg2xn1SmPmwAjmJ
         mu6nJ66KVG4A8P+1WpJpohTLA7730NlAxanEi2BAhXtAqn5W3JTXRtBwGjyJKcxK6OVx
         50KCueZXDN9SB3WLI+VVyVbC+qCSoBRKJ8lF0w+6CwdrRf5rOMTGgUcMC+M9DCuJ/eyk
         VWZyp2htjxrebZXR2rwMrkeThqjLqr7fgdz8BrcH5+8A5DdEs1BtXloVjwAwarDfKreO
         5DiuFKDz2DHcrPfslo1sPeyL9nwqx0Kv0a/3lq6KQx886FPSp9A+c4pQn2VbE7PnI94b
         7aeg==
X-Gm-Message-State: ANhLgQ1SIvCUyD239Kgr492rWaCL2MuFNge6t+e8R/5HiWX7l7kK9akY
        Kuh0YHVSJWyq8/xtdSHMFnRpMZBFPtZVcgIDTZWVCw==
X-Google-Smtp-Source: ADFU+vt120QxoRsGIUo7LYX7YrOtz0MGH7R9zC4EUX4bJ9TcmMHdG0IrAOwJcnSSrk7cTWcI/eIzyXRxb40GKoHKLow=
X-Received: by 2002:a2e:9a90:: with SMTP id p16mr18017042lji.277.1585062664389;
 Tue, 24 Mar 2020 08:11:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200323072824.254495-1-mcchou@chromium.org> <20200323002820.v1.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
 <04021BE3-63F7-4B19-9F0E-145785594E8C@holtmann.org> <421d27670f2736c88e8c0693e3ff7c0dcfceb40b.camel@perches.com>
 <57C56801-7F3B-478A-83E9-1D2376C60666@holtmann.org> <03547be94c4944ca672c7aef2dd38b0fb1eedc84.camel@perches.com>
In-Reply-To: <03547be94c4944ca672c7aef2dd38b0fb1eedc84.camel@perches.com>
From:   Alain Michaud <alainmichaud@google.com>
Date:   Tue, 24 Mar 2020 11:10:52 -0400
Message-ID: <CALWDO_U5Cnt3_Ss2QQNhtuKS_8qq7oyNH4d97J68pmbmQMe=3w@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] Bluetooth: btusb: Indicate Microsoft vendor
 extension for Intel 9460/9560 and 9160/9260
To:     Joe Perches <joe@perches.com>
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 4:11 PM Joe Perches <joe@perches.com> wrote:
>
> On Mon, 2020-03-23 at 19:48 +0100, Marcel Holtmann wrote:
> > Hi Joe,
>
> Hello Marcel.
>
> > > > > This adds a bit mask of driver_info for Microsoft vendor extension and
> > > > > indicates the support for Intel 9460/9560 and 9160/9260. See
> > > > > https://docs.microsoft.com/en-us/windows-hardware/drivers/bluetooth/
> > > > > microsoft-defined-bluetooth-hci-commands-and-events for more information
> > > > > about the extension. This was verified with Intel ThunderPeak BT controller
> > > > > where msft_vnd_ext_opcode is 0xFC1E.
> > > []
> > > > > diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> > > []
> > > > > @@ -315,6 +315,10 @@ struct hci_dev {
> > > > >         __u8            ssp_debug_mode;
> > > > >         __u8            hw_error_code;
> > > > >         __u32           clock;
> > > > > +       __u16           msft_vnd_ext_opcode;
> > > > > +       __u64           msft_vnd_ext_features;
> > > > > +       __u8            msft_vnd_ext_evt_prefix_len;
> > > > > +       void            *msft_vnd_ext_evt_prefix;
> > >
> > > msft is just another vendor.
> > >
> > > If there are to be vendor extensions, this should
> > > likely use a blank line above and below and not
> > > be prefixed with msft_
> >
> > there are other vendors, but all of them are different. So this needs to be prefixed with msft_ actually. But I agree that having empty lines above and below makes it more readable.
>
> So struct hci_dev should become a clutter
> of random vendor extensions?
>
> Perhaps there should instead be something like
> an array of char at the end of the struct and
> various vendor specific extensions could be
> overlaid on that array or just add a void *
> to whatever info that vendors require.
I don't particularly like trailing buffers, but I agree we could
possibly organize this a little better by with a struct.  something
like:

struct msft_vnd_ext {
    bool              supported; // <-- Clearly calls out if the
extension is supported.
    __u16           msft_vnd_ext_opcode; // <-- Note that this also
needs to be provided by the driver.  I don't recommend we have this
read from the hardware since we just cause an extra redirection that
isn't necessary.  Ideally, this should come from the usb_table const.
    __u64           msft_vnd_ext_features;
    __u8             msft_vnd_ext_evt_prefix_len;
    void             *msft_vnd_ext_evt_prefix;
};

And then simply add the struct msft_vnd_ext (and any others) to hci_dev.


>
>
>
