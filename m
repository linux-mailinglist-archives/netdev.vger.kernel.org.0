Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98E327D569
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 20:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgI2SH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 14:07:27 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54287 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726064AbgI2SH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 14:07:27 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4CEF55C0093;
        Tue, 29 Sep 2020 14:07:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 29 Sep 2020 14:07:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=UEhhRZ
        D1ousA3HJi4iTiQb+blUxyN/ZQnBM8gD+ztNs=; b=lQoI5B3bjnVvKIrxygGeS2
        FkMYZFO3TLfKA79VBU017HaKYuMuDdSpCaDFoUu+BD9/D+OqWkk30AlnD2vOif92
        0yW4/y3cN0MLlveVP0ehw/ZXSgzEAMKKFkI3PK1/qEEj2woXhOW6+NfP/305DIy7
        lNR/n9REOnwwyh9tbiyHFe73V+m1POy4NvIRy0F1BUbvO55riQzlRh9c1FBQB2SV
        GWS677nY4goZ/mgjD5l5jZnniXgXDPNcznn0/tHythtk67tMq2l7WyBMx2YW4URE
        RI2P0pRr+G3crxJCwHR0wUzrUTSdyV0pjmLz9/cDcycSggNa4dvAXmltm9eAZ9cQ
        ==
X-ME-Sender: <xms:3XdzX6nOufSU2jInwa3yLrJYJ4WhYfjVNmEPCojHCTWbqQsnQZzVHA>
    <xme:3XdzXx3winzOEeRF1x8BDnMNHbpXDAW8b3r7pPZ3EtabSaKfRrXHvdg5DIfFAtgKY
    Ll-9m9FDuue23s>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdekgdduvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpefgvefgveeuudeuffeiffehieffgfejleevtdetueetueffkeevgffgtddugfek
    veenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekgedrvddvledrfeejrd
    dugeeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:3XdzX4qi_lKxvUGkwijhj6DwZlg-TGZMxQ12knAwG-9I6oP7N8tHcg>
    <xmx:3XdzX-mcjuSTBbqcl7Ua5Osoxq0hI42E5Uh5OXCadkHL-IsJXWzUzw>
    <xmx:3XdzX43pwWIPuKLioruQc1V_saX_wPISihHH-yngv5Hl1J5Fy9DtHQ>
    <xmx:3ndzX9_GBTZ05wOpUAM1fT2Xotp0s6hEy_uaJ5R4k_NIQEZzsOeRfA>
Received: from localhost (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3C6483064683;
        Tue, 29 Sep 2020 14:07:25 -0400 (EDT)
Date:   Tue, 29 Sep 2020 21:07:22 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kubakici@wp.pl>, netdev@vger.kernel.org,
        snelson@pensando.io
Subject: Re: [RFC iproute2-next] devlink: display elapsed time during flash
 update
Message-ID: <20200929180722.GA1674045@shredder>
References: <20200928234945.3417905-1-jacob.e.keller@intel.com>
 <20200929101846.2a296015@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b4f664d9-301c-1157-0049-50dbea856dda@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4f664d9-301c-1157-0049-50dbea856dda@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 10:56:23AM -0700, Jacob Keller wrote:
> 
> 
> On 9/29/2020 10:18 AM, Jakub Kicinski wrote:
> > On Mon, 28 Sep 2020 16:49:45 -0700 Jacob Keller wrote:
> >> For some devices, updating the flash can take significant time during
> >> operations where no status can meaningfully be reported. This can be
> >> somewhat confusing to a user who sees devlink appear to hang on the
> >> terminal waiting for the device to update.
> >>
> >> Provide a ticking counter of the time elapsed since the previous status
> >> message in order to make it clear that the program is not simply stuck.
> >>
> >> Do not display this message unless a few seconds have passed since the
> >> last status update. Additionally, if the previous status notification
> >> included a timeout, display this as part of the message. If we do not
> >> receive an error or a new status without that time out, replace it with
> >> the text "timeout reached".
> >>
> >> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> >> ---
> >> Sending this as an RFC because I doubt this is the best implementation. For
> >> one, I get a weird display issue where the cursor doesn't always end up on
> >> the end of line in my shell.. The % display works properly, so I'm not sure
> >> what's wrong here.
> >>
> >> Second, even though select should be timing out every 1/10th of a second for
> >> screen updates, I don't seem to get that behavior in my test. It takes about
> >> 8 to 10 seconds for the first elapsed time message to be displayed, and it
> >> updates really slowly. Is select just not that precise? I even tried using a
> >> timeout of zero, but this means we refresh way too often and it looks bad. I
> >> am not sure what is wrong here...
> > 
> > Strange. Did you strace it? Perhaps it's some form of output buffering?
> > 
> 
> Haven't yet, just noticed the weird output behavior and timing
> inconsistency.

Might be similar to this:
https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=8e6bce735a132150c23503a55ea0aef55a01425f
