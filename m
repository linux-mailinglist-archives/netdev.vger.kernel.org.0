Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA5C0E77B3
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 18:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732058AbfJ1Rgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 13:36:36 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:41433 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfJ1Rgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 13:36:36 -0400
Received: by mail-pg1-f169.google.com with SMTP id l3so7342170pgr.8
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 10:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=rptm860BHGLEoa5GDqx1r11J8moja2nBrNeOQaD1UVY=;
        b=UVBIgrUV79dn/FgtGv+G6IJZln9p8w1vjCWIMjTrfzAOnajQXbTSF1+i24UykPe3yw
         uF+wgUCiPUOgqsDO2uSl/DFxewvkzXqujAH+p8Fh5SvdOV7JNEMjlmfBC+yEQRCq69lE
         6zUAFRA0Lgy8ovEYBo6fVpWOcHA1gXlUHVQL1NOxI7hdiaOA0ZfKKORoUL/s7Un/WJ9Z
         APmN/Chgfp90ciskrfArk2C6qR9XNiW0UCa8lRRI0iJl7fDfBkhJ9qwjIcaQehsswi4W
         FZu1ziNFGSPhI/sCCS6I3HS9vrd3ANrFVWrJ0VOf7SaBL9fsy4S1z4FHTNWO9jNdgXlK
         ELPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=rptm860BHGLEoa5GDqx1r11J8moja2nBrNeOQaD1UVY=;
        b=pKODA32Jn1T5IhHHrAbN1/nnu5rLaFUFjtWUzax2wQ+0K9SoXsHX3hFFqeG7JJQ3lb
         1Du0K6GdG0aUzjlCuhPhhGps3PheDi39Iaf6vAoEkX5RmtCn6KS1IOuxgE7ZUpt4K1St
         Gsg9ZKFVt9OBtaA/mHfzWT3QcjXcImSPlyR3QdR+TvApousJ7doacvAmpjrUUbKe4Wb8
         G9YBuhG5eTTBIwUdqycpMVGYUUoEnmvkt1fLDYy60oNLgAqtdSOGLfTHicmS+NlAyewu
         2u46ctt6r62cIqjKUbHojYqVR4s+aMyMz3SGnp6suMspBMB7Z6wGL01UgIUZqdIDuhu1
         FnOA==
X-Gm-Message-State: APjAAAXX93euGgKYdgreksMrRWehzcALPDu7IBEa4do7+oEzl/9eXqcW
        QeJsRFYNryEuibGKSfriJZzke1azK00=
X-Google-Smtp-Source: APXvYqxyKfLtyxPOAG2wqJWr1+OvQTSuARciT5Rv9dYwRj2XIBjKa6Eh2FFZLwiyr1x4IGiSEL80EQ==
X-Received: by 2002:a63:1f52:: with SMTP id q18mr22429682pgm.35.1572283851408;
        Mon, 28 Oct 2019 10:30:51 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w10sm134380pjq.3.2019.10.28.10.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 10:30:51 -0700 (PDT)
Date:   Mon, 28 Oct 2019 10:30:47 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Grubba, Arkadiusz" <arkadiusz.grubba@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Michael, Alice" <alice.michael@intel.com>
Subject: Re: [net-next 02/11] i40e: Add ability to display VF stats along
 with PF core stats
Message-ID: <20191028103047.6d868753@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <35C27A066ED4844F952811E08E4D95090D398A32@IRSMSX103.ger.corp.intel.com>
References: <20191023182426.13233-1-jeffrey.t.kirsher@intel.com>
        <20191023182426.13233-3-jeffrey.t.kirsher@intel.com>
        <20191023204149.4ae25f90@cakuba.hsd1.ca.comcast.net>
        <35C27A066ED4844F952811E08E4D95090D398A32@IRSMSX103.ger.corp.intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Oct 2019 13:51:07 +0000, Grubba, Arkadiusz wrote:
> Hi,

Please don't top post.

> The main info about _what_ and _why_ , as you wrote, is explained in the first (i.e. title) line.
> Namely, this change was introduced to "Add ability to display VF stats along with PF core stats" (for i40e equipment as prefix "i40e:" stands for it in the title).
> 
> (And if it was about general issues, i.e. why we introduce such changes, then, of course, they usually result mostly from the needs reported, e.g. by users using a given solution, although this does not change the nature/significance of the change from a technical point of view.)
> 
> As for further comments, that's right, you rightly notice here that the basic VF statistics are displayed and there may actually be an alternative possibility to check them (or other, newer solutions may appear that may enable it). The solution introduced here is simply one of the options (and maybe also the basis for further development of it).
> But I don't know exactly for what specific purpose you mention it here?
> What is the question? ...
> (but for sure, if I guess right what you would like to ask, it's good to keep in mind that no tool is perfectly well in itself to the full extent of all use cases or... preferences - that's why we have alternatives and generally good to have them.)
> 
> [But also, such considerations already fall, for example, into the area of user preferences. And of course, the role of this patch is not to want to influence someone's preferences but only to provide some opportunity (as opposed to limiting the possibility of using various solutions, which should probably not be our goal...)
> because among others here, this particular change is to be made available in connection with the exact and targeted needs raised by the users of the equipment affected by this code.]

It's not a matter of preference. I object to abuse of free-form APIs
for things which have proper, modern interfaces.

You're adding 12 * 128 = 1536 statistics to ethtool -S. That's
going to make the output absolutely unreadable for a human being.

> As for the last point, this is indeed some oversight - yes, the last sentence is now unnecessary after rearranging this patch to meet the final requirements / agreements for the upstream (in-tree) version of it (as I also mentioned in my previous email - see attachment).
> I think that instead of this last sentence in the commit message discussed here, and if you think it is important here, we may add (copy) from the original commit message this part of the text regarding description of displayed statistics:
> 
> +Testing hints:
> +
> +Use ethtool -S with this PF interface and check the output.
> +Extra lines with the prefix "vf" should be displayed, e.g.:
> +"
> +     vf012.rx_bytes: 69264721849
> +     vf012.rx_unicast: 45629259
> +     vf012.rx_multicast: 9
> +     vf012.rx_broadcast: 1
> +     vf012.rx_discards: 2958
> +     vf012.rx_unknown_protocol: 0
> +     vf012.tx_bytes: 93048734
> +     vf012.tx_unicast: 1409700
> +     vf012.tx_multicast: 11
> +     vf012.tx_broadcast: 0
> +     vf012.tx_discards: 0
> +     vf012.tx_errors: 0
> +"
> +(it's an example of a whole stats block for one VF).
> +
> +(For more specific tests:
> +Create some VF interfaces, link them and give them IP addresses.
> +Generate same network traffic and then follow the instructions above.)
> 
> 
> (but for me it's really not certain whether in this particular case a larger description means better, especially since it is not so important from the point of view of the functioning of the kernel / driver or the system or interaction with them.)
> 
> Best Regards
> A.G.
> 
> 
> -----Original Message-----
> From: Jakub Kicinski [mailto:jakub.kicinski@netronome.com] 
> Sent: Thursday, October 24, 2019 5:42 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; Grubba, Arkadiusz <arkadiusz.grubba@intel.com>; netdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com; Bowers, AndrewX <andrewx.bowers@intel.com>
> Subject: Re: [net-next 02/11] i40e: Add ability to display VF stats along with PF core stats
> 
> On Wed, 23 Oct 2019 11:24:17 -0700, Jeff Kirsher wrote:
> > From: Arkadiusz Grubba <arkadiusz.grubba@intel.com>
> > 
> > This change introduces the ability to display extended (enhanced) 
> > statistics for PF interfaces.
> > 
> > The patch introduces new arrays defined for these extra stats (in 
> > i40e_ethtool.c file) and enhances/extends ethtool ops functions 
> > intended for dealing with PF stats (i.e.: i40e_get_stats_count(), 
> > i40e_get_ethtool_stats(), i40e_get_stat_strings() ).  
> 
> This commit message doesn't explain _what_ stats your adding, and _why_.
> 
> From glancing at the code you're dumping 128 * 12 stats, which are basic netdev stats per-VF. 
> 
> These are trivially exposed on representors in modern designs.
> 
> > There have also been introduced the new build flag named 
> > "I40E_PF_EXTRA_STATS_OFF" to exclude from the driver code all code 
> > snippets associated with these extra stats.  
> 
> And this doesn't even exist in the patch.
> 
> > Signed-off-by: Arkadiusz Grubba <arkadiusz.grubba@intel.com>
> > Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>  
> 
> --------------------------------------------------------------------
> 
> Intel Technology Poland sp. z o.o.
> ul. Slowackiego 173 | 80-298 Gdansk | Sad Rejonowy Gdansk Polnoc | VII Wydzial Gospodarczy Krajowego Rejestru Sadowego - KRS 101882 | NIP 957-07-52-316 | Kapital zakladowy 200.000 PLN.
> 
> Ta wiadomosc wraz z zalacznikami jest przeznaczona dla okreslonego adresata i moze zawierac informacje poufne. W razie przypadkowego otrzymania tej wiadomosci, prosimy o powiadomienie nadawcy oraz trwale jej usuniecie; jakiekolwiek
> przegladanie lub rozpowszechnianie jest zabronione.
> This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). If you are not the intended recipient, please contact the sender and delete all copies; any review or distribution by
> others is strictly prohibited.

