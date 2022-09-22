Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6FD05E5CDF
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 10:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiIVIFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 04:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiIVIFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 04:05:06 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E831F578A8
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 01:04:57 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id hy2so15518086ejc.8
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 01:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=peqvwuzTwxVm+IS/9Q1M9Q7XZLLqPzAJFTVSOHEuD54=;
        b=eOPOkkn+2Diw5ZrGhr6L0K6UZMtfgwkF0lN2dbl+FcOlxNp9H7+n+B8quRoE50aAYQ
         YsViXqx0YFjcdFldfNngS/AcYUc7bpSH2QoA88g4+KdfZ/aXhOLuET4HolTD5kNpOLdP
         szFRSVuWOx6X3u2ss20Pt1bqNGuT5XPHBA89Da+1RQC6GEtqxM6tgGQ9+52oQUs9o3TJ
         pN8ktyNcprI9T56x7mc4G+DwxY2SDiKDv8zdwkdGBTRxi/OcRsVkK29D0xp90EDBxHqM
         Dqivi/QkedETG2ZkhWR195ClquntswkjkAkCEV8Vz+4VepBgXaFvfSPyHl7tMyOYawbW
         /IbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=peqvwuzTwxVm+IS/9Q1M9Q7XZLLqPzAJFTVSOHEuD54=;
        b=Zew+E4xQZ1tGW3hyO1iDcBETN60m6fQFajoQEbUMPRYipTA1Tfniu86lpZ2/0GX6uq
         GmKou6gWq1kgLJy1s6COJ5qIB1iQRFvX9wySO6lzsy1Iv7kM55bPNxIKDAkdWqlsp7vX
         C+Grg9FXtmpzizXfM6hcry8tFjqtXQZXUMpA7Qqp1qSBM0kmo3xayuYGie2JhgL6n4ZM
         QUBIuUJfeMWv/IK3chJjc7KAq/6jOJke5J1XAOEYUDByeSmWEPK5iY6xv6Ogx+JqJTPx
         nHLaw5TUrZdUW6wPH++A6/7uWGpH9xA5AfMCKga5pdQH5iwa9QLFgKyGkCP2dUQ5vtQC
         KZHA==
X-Gm-Message-State: ACrzQf3+i7aLq0YjR3g0XgodRhy1w4tPzMfmIpLRjYYymhqkqraPLB6J
        vkKibso5+CGucDryokt/MJX04Ewtgjp1lQ==
X-Google-Smtp-Source: AMsMyM605C+I/fNudehHOC0GL1+YrftCxs4qArOLY6AOkmbAS/IA2l9lKGliWnFM+F0mulRpAESTTQ==
X-Received: by 2002:a17:906:8a6c:b0:781:6a4a:11d4 with SMTP id hy12-20020a1709068a6c00b007816a4a11d4mr1768038ejc.14.1663833897438;
        Thu, 22 Sep 2022 01:04:57 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:ffea:d2d9:c85a:125a? ([2a02:578:8593:1200:ffea:d2d9:c85a:125a])
        by smtp.gmail.com with ESMTPSA id b21-20020aa7c6d5000000b0044e1b4bca41sm3191282eds.79.2022.09.22.01.04.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 01:04:56 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------wz1F5KJ9wzLGWF5YjXa0fIAp"
Message-ID: <84f45a7d-92b6-4dc5-d7a1-072152fab6ff@tessares.net>
Date:   Thu, 22 Sep 2022 10:04:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH net 2/3] can: gs_usb: gs_can_open(): fix race
 dev->can.state condition
Content-Language: en-GB
To:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, MPTCP Upstream <mptcp@lists.linux.dev>
References: <20220921083609.419768-1-mkl@pengutronix.de>
 <20220921083609.419768-3-mkl@pengutronix.de>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20220921083609.419768-3-mkl@pengutronix.de>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------wz1F5KJ9wzLGWF5YjXa0fIAp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

On 21/09/2022 10:36, Marc Kleine-Budde wrote:
> The dev->can.state is set to CAN_STATE_ERROR_ACTIVE, after the device
> has been started. On busy networks the CAN controller might receive
> CAN frame between and go into an error state before the dev->can.state
> is assigned.
> 
> Assign dev->can.state before starting the controller to close the race
> window.
> 
> Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
> Link: https://lore.kernel.org/all/20220920195216.232481-1-mkl@pengutronix.de
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

FYI, we got a small conflict when merging -net in net-next in the MPTCP
tree due to this patch applied in -net:

  5440428b3da6 ("can: gs_usb: gs_can_open(): fix race dev->can.state
condition")

and this one from net-next:

  45dfa45f52e6 ("can: gs_usb: add RX and TX hardware timestamp support")

The conflict has been resolved on our side[1] and the resolution we
suggest is attached to this email.

Cheers,
Matt

[1] https://github.com/multipath-tcp/mptcp_net-next/commit/671f1521b564
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
--------------wz1F5KJ9wzLGWF5YjXa0fIAp
Content-Type: text/x-patch; charset=UTF-8;
 name="671f1521b5648e99fb55bbd0f114e4433551d411.patch"
Content-Disposition: attachment;
 filename="671f1521b5648e99fb55bbd0f114e4433551d411.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWNjIGRyaXZlcnMvbmV0L2Nhbi91c2IvZ3NfdXNiLmMKaW5kZXggY2MzNjNmMTkz
NWNlLGMxZmYzYzA0NmQ2Mi4uNWUwZDI4MGIwY2QzCi0tLSBhL2RyaXZlcnMvbmV0L2Nhbi91
c2IvZ3NfdXNiLmMKKysrIGIvZHJpdmVycy9uZXQvY2FuL3VzYi9nc191c2IuYwpAQEAgLTk1
NiwxMSAtODIzLDggKzk1NiwxMiBAQEAgc3RhdGljIGludCBnc19jYW5fb3BlbihzdHJ1Y3Qg
bmV0X2RldmljCiAgCWlmIChjdHJsbW9kZSAmIENBTl9DVFJMTU9ERV8zX1NBTVBMRVMpCiAg
CQlmbGFncyB8PSBHU19DQU5fTU9ERV9UUklQTEVfU0FNUExFOwogIAogKwkvKiBpZiBoYXJk
d2FyZSBzdXBwb3J0cyB0aW1lc3RhbXBzLCBlbmFibGUgaXQgKi8KICsJaWYgKGRldi0+ZmVh
dHVyZSAmIEdTX0NBTl9GRUFUVVJFX0hXX1RJTUVTVEFNUCkKICsJCWZsYWdzIHw9IEdTX0NB
Tl9NT0RFX0hXX1RJTUVTVEFNUDsKICsKICAJLyogZmluYWxseSBzdGFydCBkZXZpY2UgKi8K
KyAJZGV2LT5jYW4uc3RhdGUgPSBDQU5fU1RBVEVfRVJST1JfQUNUSVZFOwogIAlkbS0+bW9k
ZSA9IGNwdV90b19sZTMyKEdTX0NBTl9NT0RFX1NUQVJUKTsKICAJZG0tPmZsYWdzID0gY3B1
X3RvX2xlMzIoZmxhZ3MpOwogIAlyYyA9IHVzYl9jb250cm9sX21zZyhpbnRlcmZhY2VfdG9f
dXNiZGV2KGRldi0+aWZhY2UpLApAQEAgLTk3NywxMiAtODQyLDYgKzk3OSwxMCBAQEAKICAK
ICAJa2ZyZWUoZG0pOwogIAogKwkvKiBzdGFydCBwb2xsaW5nIHRpbWVzdGFtcCAqLwogKwlp
ZiAoZGV2LT5mZWF0dXJlICYgR1NfQ0FOX0ZFQVRVUkVfSFdfVElNRVNUQU1QKQogKwkJZ3Nf
dXNiX3RpbWVzdGFtcF9pbml0KGRldik7CiArCi0gCWRldi0+Y2FuLnN0YXRlID0gQ0FOX1NU
QVRFX0VSUk9SX0FDVElWRTsKLSAKICAJcGFyZW50LT5hY3RpdmVfY2hhbm5lbHMrKzsKICAJ
aWYgKCEoZGV2LT5jYW4uY3RybG1vZGUgJiBDQU5fQ1RSTE1PREVfTElTVEVOT05MWSkpCiAg
CQluZXRpZl9zdGFydF9xdWV1ZShuZXRkZXYpOwo=

--------------wz1F5KJ9wzLGWF5YjXa0fIAp--
