Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DFB2623A9
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 01:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgIHXkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 19:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgIHXkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 19:40:13 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75EAC061573;
        Tue,  8 Sep 2020 16:40:12 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gf14so388558pjb.5;
        Tue, 08 Sep 2020 16:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:cc:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=hlDVAxiOXkRKboZyuXLRZYuEvx2EuGrMs+4z282NJ3Y=;
        b=QCKvxLSP+l1V9OAeyZI/eFqDi+o8xjfqGqlnLNw2npgUS4C+jvj4OFa8mylIOnw3Ya
         6XQ4b+YzF5X9xeqEUid7qQRjOB9Dem84hWXdxpsGL8sjROMTUh3iAWiNrNF9M3+rWL7n
         n9sok6QaHG4mV+vLLGOTzpaidSM9QmP8YgreeIXtxitNsKvIN0/6QDYW8gmYt1rVuZIk
         WvUvncHViZB02CafjeKUSYsZvHB0/zVBwTC8G0NsLQOQ9JjvpVBi/P7vIRRDy2di+afK
         mnWtbJTUj/fdx2pcCy+yHdsQp4kGxuuMSzg54VuGNCehCOYmakULd1OvB5Hkwwss6Liw
         Za5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hlDVAxiOXkRKboZyuXLRZYuEvx2EuGrMs+4z282NJ3Y=;
        b=pyXsQ7zneQFFktdLUplpSJsluXHGNejYsTI58rdJmhi6vyK9XsHtICP4mNMtf2ggIH
         I+0o8K/d0mQczrzKAU2V8kNYkyPvLV78OPewoUtzCFkDCVWt6QZiJC9DGreCYxgNIre+
         YnLCN6Ryrb9Pl1uNMjIzPwKiNODXsq3ak1EkTYpGRxoUYPwcUFCOLu2bwe6hU4VR8Df6
         0p+QOSwZBtNrFrP/cjPHkpfWvHwbmrPOI/U0kuHTmFF/Aanl3r6/7jYMeZrq/Z5ylUzl
         PNJMoMEZ/P60e8XM1a7kGkemNjl398eHBxxGjhztbCo5LXHJoqZBAhHO2BaIedG1jDPt
         s2Tg==
X-Gm-Message-State: AOAM530bvBgQ6wRqY0OTjwxeQNIdIuzOkWVlDf3GarBsK2RTCanq13O1
        nbmcxg0XWnbFVy/AY2jc9dDovlSScLvWn7zJlpM=
X-Google-Smtp-Source: ABdhPJy8Y2WGjmhgmk0S8gNJ7jMT9iROaroU3DMIfr/Z94bKZkvSEbg5xsHM6Wzs15kPEkaLO+/14w==
X-Received: by 2002:a17:902:bb84:: with SMTP id m4mr1003130pls.90.1599608411843;
        Tue, 08 Sep 2020 16:40:11 -0700 (PDT)
Received: from [192.168.0.104] ([49.207.193.206])
        by smtp.gmail.com with ESMTPSA id 31sm310969pgs.59.2020.09.08.16.40.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 16:40:11 -0700 (PDT)
Subject: Re: [PATCH] net: qrtr: Reintroduce ARCH_QCOM as a dependency for QRTR
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+c613e88b3093ebf3686e@syzkaller.appspotmail.com,
        syzbot+d0f27d9af17914bf253b@syzkaller.appspotmail.com,
        syzbot+3025b9294f8cb0ede850@syzkaller.appspotmail.com,
        syzbot+0f84f6eed90503da72fc@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Masahiro Yamada <masahiroy@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200908233329.200473-1-anant.thazhemadam@gmail.com>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <03d5b23d-b81a-f9b2-c42d-90b3a8e021f2@gmail.com>
Date:   Wed, 9 Sep 2020 05:10:06 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200908233329.200473-1-anant.thazhemadam@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 09/09/20 5:03 am, Anant Thazhemadam wrote:
> Removing ARCH_QCOM, as a dependency for QRTR begins to give rise to
> issues with respect to maintaining reference count integrity and
> suspicious rcu usage.
>
> The bugs resolved by making QRTR dependent on ARCH_QCOM include:
>
> * WARNING: refcount bug in qrtr_node_lookup
> Reported-by: syzbot+c613e88b3093ebf3686e@syzkaller.appspotmail.com
> * WARNING: refcount bug in qrtr_recvmsg
> Reported-by: syzbot+d0f27d9af17914bf253b@syzkaller.appspotmail.com
> * WARNING: suspicious RCU usage in ctrl_cmd_new_lookup
> Reported-by: syzbot+3025b9294f8cb0ede850@syzkaller.appspotmail.com
> * WARNING: suspicious RCU usage in qrtr_ns_worker
> Reported-by: syzbot+0f84f6eed90503da72fc@syzkaller.appspotmail.com
>
> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
> ---
> As I understand it, QRTR was initially dependent upon ARCH_QCOM, but was 
> removed since not all modems using IPC Router protocol required the 
> support provided for Qualcomm platforms. 
> However, wouldn't ARCH_QCOM be required by the modems that require the 
> support provided for Qualcomm platforms?
> The configuration ARCH_QCOM isn't exactly the easiest to find, especially, 
> for those who don't know what they're looking for (syzbot included, I 
> guess).
> I don't feel like the tradeoff of not depending on ARCH_QCOM over giving 
> rise to potential bugs is worth it. 
> Is NOT having QRTR depend on ARCH_QCOM so critical that it supersedes the 
> priority of not giving rise to potential bugs?
>
>  net/qrtr/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/qrtr/Kconfig b/net/qrtr/Kconfig
> index b4020b84760f..8156d0f3656b 100644
> --- a/net/qrtr/Kconfig
> +++ b/net/qrtr/Kconfig
> @@ -4,6 +4,7 @@
>  
>  config QRTR
>  	tristate "Qualcomm IPC Router support"
> +	depends on ARCH_QCOM
>  	help
>  	  Say Y if you intend to use Qualcomm IPC router protocol.  The
>  	  protocol is used to communicate with services provided by other
I believe I've been mistaken. I realize, requiring ARCH_QCOM wouldn't
extend functionality, but would limit it to ONLY Qualcomm platforms.
That makes sense, and would also explain the false positive results
obtained when tried to test with syzbot, since syzbot wouldn't be
able to build in the first place.

Sorry for the trouble, you may ignore this patch.

thanks,
Anant

