Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 634FC85B4B
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 09:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731226AbfHHHKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 03:10:52 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54184 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730910AbfHHHKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 03:10:51 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 61E6E602BC; Thu,  8 Aug 2019 07:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565248250;
        bh=Gqbmq5rn8ky7RLP8vrGJolEOPnLSsYYhH0jYpshbEqQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MD08oGuVgoAryDGKOyLaRIE1Xz78HGIXPJP2vvcIwme6Q06Ux4nDotts+fFYk8s4s
         bTTUsHxz0TM0v4HelNGxKz/jn2FK1Rb72w9q5C2VfcKtm5dRD8hBfbOafQbcLMpG4n
         x6N2lJOUribTRreaGwZvqoqeZHuN8vbcdjfQpYsc=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 003AE602BC;
        Thu,  8 Aug 2019 07:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565248249;
        bh=Gqbmq5rn8ky7RLP8vrGJolEOPnLSsYYhH0jYpshbEqQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cdjrC6KyMaYP6xjWN9YWXcrbXtPRURu85FLY+7vEX2jjSL84VD8nW6SXpX2hAgnrf
         36CdDPDsqahdmp3dxyZJgytKZqwq8DwL9xD1ZUiofjePHy1zapd04XTyhvX0EukK/D
         kIvYEwCRE4XolY8/WWeav5URR52LD/6OsITyRbAk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 003AE602BC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Valdis =?utf-8?Q?Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Fix non-kerneldoc comment in realtek/rtlwifi/usb.c
References: <34195.1565229118@turing-police>
        <15df2564-8815-f351-8fb2-b46611a90234@lwfinger.net>
Date:   Thu, 08 Aug 2019 10:10:45 +0300
In-Reply-To: <15df2564-8815-f351-8fb2-b46611a90234@lwfinger.net> (Larry
        Finger's message of "Wed, 7 Aug 2019 21:07:40 -0500")
Message-ID: <877e7odte2.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 8/7/19 8:51 PM, Valdis Kl=C4=93tnieks wrote:
>> Fix spurious warning message when building with W=3D1:
>>
>>    CC [M]  drivers/net/wireless/realtek/rtlwifi/usb.o
>> drivers/net/wireless/realtek/rtlwifi/usb.c:243: warning: Cannot understa=
nd  * on line 243 - I thought it was a doc line
>> drivers/net/wireless/realtek/rtlwifi/usb.c:760: warning: Cannot understa=
nd  * on line 760 - I thought it was a doc line
>> drivers/net/wireless/realtek/rtlwifi/usb.c:790: warning: Cannot understa=
nd  * on line 790 - I thought it was a doc line
>>
>> Clean up the comment format.
>>
>> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
>>
>> ---
>> Changes since v1:  Larry Finger pointed out the patch wasn't checkpatch-=
clean.
>>
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wi=
reless/realtek/rtlwifi/usb.c
>> index 34d68dbf4b4c..4b59f3b46b28 100644
>> --- a/drivers/net/wireless/realtek/rtlwifi/usb.c
>> +++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
>> @@ -239,10 +239,7 @@ static void _rtl_usb_io_handler_release(struct ieee=
80211_hw *hw)
>>   	mutex_destroy(&rtlpriv->io.bb_mutex);
>>   }
>>   -/**
>> - *
>> - *	Default aggregation handler. Do nothing and just return the oldest s=
kb.
>> - */
>> +/*	Default aggregation handler. Do nothing and just return the oldest s=
kb.  */
>>   static struct sk_buff *_none_usb_tx_aggregate_hdl(struct ieee80211_hw =
*hw,
>>   						  struct sk_buff_head *list)
>>   {
>> @@ -756,11 +753,6 @@ static int rtl_usb_start(struct ieee80211_hw *hw)
>>   	return err;
>>   }
>>   -/**
>> - *
>> - *
>> - */
>> -
>>   /*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  tx =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D*/
>>   static void rtl_usb_cleanup(struct ieee80211_hw *hw)
>>   {
>> @@ -786,11 +778,7 @@ static void rtl_usb_cleanup(struct ieee80211_hw *hw)
>>   	usb_kill_anchored_urbs(&rtlusb->tx_submitted);
>>   }
>>   -/**
>> - *
>> - * We may add some struct into struct rtl_usb later. Do deinit here.
>> - *
>> - */
>> +/* We may add some struct into struct rtl_usb later. Do deinit here.  */
>>   static void rtl_usb_deinit(struct ieee80211_hw *hw)
>>   {
>>   	rtl_usb_cleanup(hw);
>
> I missed that the subject line should be "rtwifi: Fix ....". Otherwise it=
 is OK.

I can fix the subject during commit.

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
