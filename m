Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFB9385C92
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 10:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732006AbfHHIOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 04:14:04 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:47052 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731781AbfHHIOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 04:14:04 -0400
Received: by mail-ot1-f66.google.com with SMTP id z23so6973880ote.13;
        Thu, 08 Aug 2019 01:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aYc/fc0DGbtltCecOiZ42Q6vOGrrQUgvpSTpwJEiq3I=;
        b=a289ZnMYfQ/po7+vfNhUyM/J6ww22Y2jhZP0KOPGynknnV2NJiu0Pk7vrnRA+44rIN
         FJKlDoFSoLeq4X087B2CjQKvUBBuoAqra7M0gQlVvFuMyXxkB5sfF2RrTGyt9ptr24Vu
         /KMPX61+CBCa075MJJw+ZDqTRKLrL7PE9pf26b7s0rldnZLVI8FwdpH7S/k7ojR+BqSi
         Jt9V1qKzRPUzOo0qaV8bsm7sFgY3KkLRWfhbG9xQcDU9U1GvSfEk35HuPwuFdJYz2jao
         PyXy4H2SFwYvG1mxgokzISbk4BsUUk/gWWelumBCtPW3nF4C3v1zn7O0qmgdSMCIGORv
         bRZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aYc/fc0DGbtltCecOiZ42Q6vOGrrQUgvpSTpwJEiq3I=;
        b=eQzCVPl+guuDPb6R36yUvKbtMSOj/g1xJBbwaXZ3QcrYRdEEhMxgL96nb5uyR1fQFL
         NK9t18CMTIdS1AYtEl8LnfbAeU30uMOUp5a0wGhVbBJoTMKW0An5fwto1zdVd/Ijomgr
         rGyW45cJ0M8l1mngYBjIfaZb1SmDVRWvexn7HfvzPFxoueFAPH26uPBRn0KBlqWhFDxj
         nJzwTsH5IUgCCX2mo7OdkweBM4LLDgUPIDiG+Iel0cAKbbpiIZiiZxceOeljdETjeqVg
         7mdycokrEfa9npwhQy60GgF6ftFnwC8Z+0r7yEx/SYbom4yDOD/y4Rd620gXNpQKUCZb
         byiQ==
X-Gm-Message-State: APjAAAUmAoWJYaBE+pP9pz9T5Cf6EZFydEvnBB5F2vjm21Tq6LqouaRY
        4qBFTSL1F5HflTQEWEAFbUcJUNOt
X-Google-Smtp-Source: APXvYqxzmR8GRo68Eu8Mczl6JKSliOBoEHOHcBKOcCXXTMVc0ZPd/qRDCCLbplRI+89NQJQj7HJQrA==
X-Received: by 2002:a9d:7cd1:: with SMTP id r17mr12052163otn.356.1565252043247;
        Thu, 08 Aug 2019 01:14:03 -0700 (PDT)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id d22sm31412123oig.38.2019.08.08.01.14.02
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 01:14:02 -0700 (PDT)
Subject: Re: [PATCH v2] Fix non-kerneldoc comment in realtek/rtlwifi/usb.c
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     =?UTF-8?Q?Valdis_Kl=c4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <34195.1565229118@turing-police>
 <15df2564-8815-f351-8fb2-b46611a90234@lwfinger.net>
 <877e7odte2.fsf@kamboji.qca.qualcomm.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <01fcbe35-e004-a9bf-c180-3e75fa3ab427@lwfinger.net>
Date:   Thu, 8 Aug 2019 03:14:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <877e7odte2.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/8/19 2:10 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
> 
>> On 8/7/19 8:51 PM, Valdis Klētnieks wrote:
>>> Fix spurious warning message when building with W=1:
>>>
>>>     CC [M]  drivers/net/wireless/realtek/rtlwifi/usb.o
>>> drivers/net/wireless/realtek/rtlwifi/usb.c:243: warning: Cannot understand  * on line 243 - I thought it was a doc line
>>> drivers/net/wireless/realtek/rtlwifi/usb.c:760: warning: Cannot understand  * on line 760 - I thought it was a doc line
>>> drivers/net/wireless/realtek/rtlwifi/usb.c:790: warning: Cannot understand  * on line 790 - I thought it was a doc line
>>>
>>> Clean up the comment format.
>>>
>>> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
>>>
>>> ---
>>> Changes since v1:  Larry Finger pointed out the patch wasn't checkpatch-clean.
>>>
>>> diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
>>> index 34d68dbf4b4c..4b59f3b46b28 100644
>>> --- a/drivers/net/wireless/realtek/rtlwifi/usb.c
>>> +++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
>>> @@ -239,10 +239,7 @@ static void _rtl_usb_io_handler_release(struct ieee80211_hw *hw)
>>>    	mutex_destroy(&rtlpriv->io.bb_mutex);
>>>    }
>>>    -/**
>>> - *
>>> - *	Default aggregation handler. Do nothing and just return the oldest skb.
>>> - */
>>> +/*	Default aggregation handler. Do nothing and just return the oldest skb.  */
>>>    static struct sk_buff *_none_usb_tx_aggregate_hdl(struct ieee80211_hw *hw,
>>>    						  struct sk_buff_head *list)
>>>    {
>>> @@ -756,11 +753,6 @@ static int rtl_usb_start(struct ieee80211_hw *hw)
>>>    	return err;
>>>    }
>>>    -/**
>>> - *
>>> - *
>>> - */
>>> -
>>>    /*=======================  tx =========================================*/
>>>    static void rtl_usb_cleanup(struct ieee80211_hw *hw)
>>>    {
>>> @@ -786,11 +778,7 @@ static void rtl_usb_cleanup(struct ieee80211_hw *hw)
>>>    	usb_kill_anchored_urbs(&rtlusb->tx_submitted);
>>>    }
>>>    -/**
>>> - *
>>> - * We may add some struct into struct rtl_usb later. Do deinit here.
>>> - *
>>> - */
>>> +/* We may add some struct into struct rtl_usb later. Do deinit here.  */
>>>    static void rtl_usb_deinit(struct ieee80211_hw *hw)
>>>    {
>>>    	rtl_usb_cleanup(hw);
>>
>> I missed that the subject line should be "rtwifi: Fix ....". Otherwise it is OK.
> 
> I can fix the subject during commit.

OK. Acked-by: Larry Finger<Larry.Finger@lwfinger.net>

Thanks,

Larry


