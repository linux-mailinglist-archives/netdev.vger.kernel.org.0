Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D029D15C629
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 17:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387465AbgBMP5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 10:57:54 -0500
Received: from mail-ed1-f53.google.com ([209.85.208.53]:37518 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727964AbgBMP5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 10:57:49 -0500
Received: by mail-ed1-f53.google.com with SMTP id df17so665776edb.4
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 07:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OiFCwTHGnxWOPqya1mGqa2xpgcV+wBJ/acYQ6pZEZCo=;
        b=VLIrUR4p+9YWt9WEV6E9JheOJv1TRDUNNZTsY4X0w2guWYJVphHNzLWw3gqGkzw3+1
         iHJBFcfGoVE8XupTLVIKswYSD8+foi7aYwn2CljB8vjGzca/QWhmRmaUnxPpRsI9Iq3R
         03zvj1/mgp15tdpmo1vu9FriaE/knI8RhvEUJ6yilLZel13bi+Kjvo0/wKaagd76weEZ
         V0A2MGPnRXb/Dhm0BxkbfDwQAfNnz4QzWhEJPqQY0FOlSoAgRA4rMVqCbXRDzJBjQbnU
         nqdrHvXroUBTJRz+VsSa6T883/bGspCKA4R9Uc+WBmBAJMKn97y6KhJffoKV1aKpEDJO
         SKFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OiFCwTHGnxWOPqya1mGqa2xpgcV+wBJ/acYQ6pZEZCo=;
        b=Z4vEeDMIFFT6Okx6a+VlaONKSpNBgD2+q7HPW4Einm6DalYtpM0hfcyefWVVRaqcVD
         SxuNA0wAH9JnVaMhX5tovC6ffEo+1kKjzhvUBQhE/lr41iyO8m0OOomO2Zur8b+YKVrI
         yvvnovp73VGz/FzIcByIQzuvxpuGIkeOY4/94TMFbYsfVCfsIoIrV2/sZLkEi+B4ZNl5
         DJj0/ssOyBNJXjOON+A19G6LnN68CR14WrYqSialoacll8nCn02o8o+TXpYgiilsbWjc
         tAT0BpBDAKdBDrinPHpxYhmwIpr4bzbPXDfHfNIqhy1WQ2NWgbUnxFNCmfpDMvvvrDqd
         NIzQ==
X-Gm-Message-State: APjAAAVmZc4w0Mhh/3nyPGZdFdNgN//fjr1GyENqu+cdhqUThAtcjvpe
        9FShPSgQ81pW6vZ9OKGzNnhuCUcMijDzRVFu+PNqjg==
X-Google-Smtp-Source: APXvYqwygQORcCpVsZxOojw5HTsTUB62JJK2WMcPPLcON8ZFo+QFqjqpZ7RhttzBuC1Gl8w4s1XxN/UnQ1dHyE94Lu8=
X-Received: by 2002:a17:906:7a07:: with SMTP id d7mr9321225ejo.176.1581609467163;
 Thu, 13 Feb 2020 07:57:47 -0800 (PST)
MIME-Version: 1.0
References: <20200213133831.GM25745@shell.armlinux.org.uk> <20200213144615.GH18808@shell.armlinux.org.uk>
In-Reply-To: <20200213144615.GH18808@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 13 Feb 2020 17:57:36 +0200
Message-ID: <CA+h21ho=siWbp9B=sC5P-Z5B2YEtmnjxnZLzwSwfcVHBkO6rKA@mail.gmail.com>
Subject: Re: Heads up: phylink changes for next merge window
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Thu, 13 Feb 2020 at 16:46, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> [Recipient list updated; removed addresses that bounce, added Ioana
> Ciornei for dpaa2 and DSA issue mentioned below.]
>
> On Thu, Feb 13, 2020 at 01:38:31PM +0000, Russell King - ARM Linux admin wrote:
> > Hi,
>
> I should also have pointed out that with mv88e6xxx, the patch
> "net: mv88e6xxx: use resolved link config in mac_link_up()" "fixes" by
> side-effect an issue that Andrew has mentioned, where inter-DSA ports
> get configured down to 10baseHD speed.  This is by no means a true fix
> for that problem - which is way deeper than this series can address.
> The reason it fixes it is because we no longer set the speed/duplex
> in mac_config() but set it in mac_link_up() - but mac_link_up() is
> never called for CPU and DSA ports.
>
> However, I think there may be another side-effect of that - any fixed
> link declaration in DT may not be respected after this patch.
>
> I believe the root of this goes back to this commit:
>
>   commit 0e27921816ad99f78140e0c61ddf2bc515cc7e22
>   Author: Ioana Ciornei <ioana.ciornei@nxp.com>
>   Date:   Tue May 28 20:38:16 2019 +0300
>
>   net: dsa: Use PHYLINK for the CPU/DSA ports
>
> and, in the case of no fixed-link declaration, phylink has no idea what
> the link parameters should be (and hence the initial bug, where
> mac_config gets called with speed=0 duplex=0, which gets interpreted as
> 10baseHD.)  Moreover, as far as phylink is concerned, these links never
> come up. Essentially, this commit was not fully tested with inter-DSA
> links, and probably was never tested with phylink debugging enabled.
>
> There is currently no fix for this, and it is not an easy problem to
> resolve, irrespective of the patches I'm proposing.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

Correct me if I'm wrong, but if the lack of fixed-link specifier for
CPU and DSA ports was not a problem before, but has suddenly started
to become a problem with that patch, then simply reverting to the old
"legacy" logic from dsa_port_link_register_of() should restore the
behavior for those device tree blobs that don't specify an explicit
fixed-link?
In the longer term, can't we just require fixed-link specifiers for
non-netdev ports on new boards, keep the adjust_link code in DSA for
the legacy blobs (which works through some sort of magic), and be done
with it?

Regards,
-Vladimir
