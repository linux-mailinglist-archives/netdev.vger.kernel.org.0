Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CE84E879E
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 14:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbiC0MHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 08:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiC0MHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 08:07:10 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B706013D69;
        Sun, 27 Mar 2022 05:05:31 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id b24so14014334edu.10;
        Sun, 27 Mar 2022 05:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GnTwoiHEQ0005E7ajdlDmwONStYExlB/QvWk5f0jJ8A=;
        b=hPapNzUdKjpjIWSPLoa82GQAIvgf0mp3A+nEIuW7/H8IaBEaG2W+/cZcabMryZyUBT
         YJ4nc0pKzLxmBD9NlrkpHxP+MSQOp0cL2Fx6HOrxbzm3r+2NF5RHu6z4deMgbGtRrBSY
         QbZKbY/8GCsIsjtAu8Js/t7u4ZKo+6LlDb7TctkhW+f4wIImbsdzvoAVy6gBf/xu2SZu
         jHFmMjFfC+YOlUTWsffCfltIHnz5kgSOh3/toljpRkVlMpNZa/Axky9XOlIap/4k/vhb
         8PPOkL3DTQ54g7cjV5zY2t4cKCUqBqC0NO1BFZ9akoWoxCYYSYYWus4MHu013J0alnj8
         mRlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GnTwoiHEQ0005E7ajdlDmwONStYExlB/QvWk5f0jJ8A=;
        b=iuTwUUFDwwHYCXCqdZQ4+mEMpmsB1/k7Y5sTbVpPYyFXI53yawVkkY+FHKQE2q1pKx
         sPVsqStu5m4ldGTGEyru3nxspWCWovkurerfr1KsQuxYxH1F7pWzr0bXN+VR3Gv3TmKP
         t2mYugnxIyCfPOAYF+qV3nddih59oRWrhVSM/G7CDodzqKIGNvp1ywWvVmA4vYKAMf7J
         DyU3D5Ob4T9pSMUi23r4/gfDUb5lmaHXZ3HJxSu45IWLUJF9IE47PpHdT+0WjShCA78r
         5HexceRDRaMZfMXGq0oFgaTv52JCdd2lH/w5nAXCVdDHk48uLcxPaKtZNXq9vpSAk2Ly
         to8g==
X-Gm-Message-State: AOAM530WXNwqQs2Gkt5s60hefHuAbdbDFIdrmjXiqtZMVnEpDxOYPbRg
        5CGAlg248VQWSrrRobR5FxjqapgjzgE=
X-Google-Smtp-Source: ABdhPJwYTI3OOciolEDuZ7us/NxODvs+sY1Sajla/idAJekrFdvrkrkdl/sVVsKpeW7AeDWv8txqpQ==
X-Received: by 2002:aa7:c64c:0:b0:418:ecf7:afaa with SMTP id z12-20020aa7c64c000000b00418ecf7afaamr10296654edr.38.1648382730098;
        Sun, 27 Mar 2022 05:05:30 -0700 (PDT)
Received: from debian64.daheim (p4fd09fe6.dip0.t-ipconnect.de. [79.208.159.230])
        by smtp.gmail.com with ESMTPSA id h8-20020a1709066d8800b006e09a49a713sm3077371ejt.159.2022.03.27.05.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 05:05:29 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1nYRbZ-0002uT-2x;
        Sun, 27 Mar 2022 14:05:29 +0200
Message-ID: <a5689ba5-2a88-2bef-348b-5bec5cbc3b60@gmail.com>
Date:   Sun, 27 Mar 2022 14:05:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] carl9170: main: fix an incorrect use of list iterator
Content-Language: de-DE
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>, chunkeey@googlemail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220327072702.10572-1-xiam0nd.tong@gmail.com>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20220327072702.10572-1-xiam0nd.tong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 27/03/2022 09:27, Xiaomeng Tong wrote:
> The bug is here:
> 	rcu_assign_pointer(ar->tx_ampdu_iter,
> 		(struct carl9170_sta_tid *) &ar->tx_ampdu_list);

yeah, so... I know there's currently a big discussion revolving
around LISTs due to incoming the GNU89 to GNU11 switch. I'm not
currently aware that something related to this had updated
INIT_LIST_HEAD + friends. So, please tell me if there is extra
information that has to be considered.

> The 'ar->tx_ampdu_iter' is used as a list iterator variable
> which point to a structure object containing the list HEAD
> (&ar->tx_ampdu_list), not as the HEAD itself.
> 
> The only use case of 'ar->tx_ampdu_iter' is as a base pos
> for list_for_each_entry_continue_rcu in carl9170_tx_ampdu().
> If the iterator variable holds the *wrong* HEAD value here
> (has not been modified elsewhere before), this will lead to
> an invalid memory access.
> 
> Using list_entry_rcu to get the right list iterator variable
> and reassign it, to fix this bug.
> Note: use 'ar->tx_ampdu_list.next' instead of '&ar->tx_ampdu_list'
> to avoid compiler error.
> 
> Cc: stable@vger.kernel.org
> Fixes: fe8ee9ad80b28 ("carl9170: mac80211 glue and command interface")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>   drivers/net/wireless/ath/carl9170/main.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
> index 49f7ee1c912b..a287937bf666 100644
> --- a/drivers/net/wireless/ath/carl9170/main.c
> +++ b/drivers/net/wireless/ath/carl9170/main.c
> @@ -1756,6 +1756,7 @@ static const struct ieee80211_ops carl9170_ops = {
>   
>   void *carl9170_alloc(size_t priv_size)
>   {
> +	struct carl9170_sta_tid *tid_info;
>   	struct ieee80211_hw *hw;
>   	struct ar9170 *ar;
>   	struct sk_buff *skb;
> @@ -1815,8 +1816,9 @@ void *carl9170_alloc(size_t priv_size)
>   	INIT_DELAYED_WORK(&ar->stat_work, carl9170_stat_work);
>   	INIT_DELAYED_WORK(&ar->tx_janitor, carl9170_tx_janitor);
>   	INIT_LIST_HEAD(&ar->tx_ampdu_list);
> -	rcu_assign_pointer(ar->tx_ampdu_iter,
> -			   (struct carl9170_sta_tid *) &ar->tx_ampdu_list);
> +	tid_info = list_entry_rcu(ar->tx_ampdu_list.next,
> +				struct carl9170_sta_tid, list);
> +	rcu_assign_pointer(ar->tx_ampdu_iter, tid_info);


I've tested this. I've added the following pr_info that would
print the (raw) pointer of both your new method (your patch)
and the old (current code) one:

  pr_info("new:%px\n", list_entry_rcu(ar->tx_ampdu_list.next,struct carl9170_sta_tid, list)); // tid_info
  pr_info("old:%px\n", (struct carl9170_sta_tid *) &ar->tx_ampdu_list);

and run it on AR9170 USB Stick

[  216.547932] usb 2-10: SerialNumber: 12345
[  216.673629] usb 2-10: reset high-speed USB device number 10 using xhci_hcd
[  216.853488] new:ffff9394268a38e0
[  216.853496] old:ffff9394268a38e0
[  216.858174] usb 2-10: driver   API: 1.9.9 2016-02-15 [1-1]
[  216.858186] usb 2-10: firmware API: 1.9.9 2021-02-05

phew, what a relieve :). Both the new and old pointers are the same.

So, the tx_ampdu_list is empty, as it was just initialized to
(list->next = list->prev = list).

And you are right about the iter being suspeciously bogus. But I think
this is true for both the new and the old way. There is no real
carl9170_sta_tid* tid associated with that empty entry and if some code
would expect a valid carl9170_sta_tid* there, it would certainly cause
crashes&burns.

The carl9170_tx_ampdu() and carl9170_ampdu_gc() code is really
careful though and checks whenever the list is empty or not
before doing any list traversing with the tx_ampdu_iter.

Any thoughts or insights?

Cheers,
Christian
