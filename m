Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57ECE6F1D29
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 19:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbjD1RGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 13:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjD1RGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 13:06:07 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D6A2710;
        Fri, 28 Apr 2023 10:06:06 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-187de655f15so112352fac.3;
        Fri, 28 Apr 2023 10:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682701565; x=1685293565;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:sender:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZwebSDbcEiTndvqleOUsphstm5KG1oepB9XO0kR9wf8=;
        b=BBr99xho1LlxU8yTwHav1CVabMGj74RB2kcJZSHl1Ixjx+HGbxjXcvOjbgdEbgQPRl
         BHAqjKhRKP0/nl0ewyz/GN+3tH6/0/LS8cZI6SMwv9cOZnXnAmkBBBeG8nCqvEYO7/m1
         sa5miVL3/Gt6znLlvNJ4ODCbiH/HRxxzQmY4Bdy39oEKbRbzz3DW7brnan9YeVOqNPnH
         W4AgqnkjyLWu0ugyf2IoUX0bkx6Jle+erxffw2Pij9I7ZT7574rpch0SZeDHN5yuswVt
         oGqb9cnpJrfJvJgciMlJxaSwZ59EIkBRI6OFr5/UUGMVO4nmbbbZrQ1v63cxFRAnQVVk
         0/JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682701565; x=1685293565;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:sender:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZwebSDbcEiTndvqleOUsphstm5KG1oepB9XO0kR9wf8=;
        b=bJnurwQzwQ5NXyYBQP015Bd8v1S7eDLoUncBtFCd/HhOuH1nEYDDHnmoh3nxB2T+I+
         GXf/jqNanRwUkx2QiMf2hLHw1nsCAk5JZWtO7g7Y07BoaheEEwq4pKnO3ScDP4g1hJmI
         tumR79jVpkY69hX4ijjDZ3TW562enVnTA0j4jiwdVbzFxpO5gkop+0/QQLQxRqd6rKgo
         6nlkuwF0PTIvx3tSF4Gy9nkcvyhamo9KvmfzKWBDkBqnRK85k+L7sttyyKgDyGUO97u1
         iEZ68b0f/x33+y0l6Y6ZkxpOAXyY7bCF6V7oYA1DWBFv92ezdONqlh0RO5EWmUS28CPT
         /6sA==
X-Gm-Message-State: AC+VfDxR5YmMUbx8pTeKjgHCSRu5bErSt9slaaQ82FLraoJK8McnAWIP
        pPOyW14mbHdOBWeGWKOH0txbgEER5Q8=
X-Google-Smtp-Source: ACHHUZ6+9URlmsDBIOBUx8ggs+K/eEFuaPbj0Nf7i29aDO8gnip9GNXbXEzd/J45opRZeH7rg9RQvg==
X-Received: by 2002:a54:4098:0:b0:384:833:2a79 with SMTP id i24-20020a544098000000b0038408332a79mr2919330oii.48.1682701565329;
        Fri, 28 Apr 2023 10:06:05 -0700 (PDT)
Received: from [192.168.0.162] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id p203-20020acaf1d4000000b0038cabfcb3ccsm9061020oih.15.2023.04.28.10.06.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 10:06:04 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Content-Type: multipart/mixed; boundary="------------dXNjmVauvoy0tmBnxkx4nmvc"
Message-ID: <d3743b66-23b1-011c-9dcd-c408b1963fca@lwfinger.net>
Date:   Fri, 28 Apr 2023 12:06:03 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] wifi: rtl8xxxu: fix authentication timeout due to
 incorrect RCR value
Content-Language: en-US
To:     wo <luyun_611@163.com>
Cc:     Jes.Sorensen@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20230427020512.1221062-1-luyun_611@163.com>
 <866570c9-38d8-1006-4721-77e2945170b9@lwfinger.net>
 <76a784b2.2cb3.187c60f0f68.Coremail.luyun_611@163.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <76a784b2.2cb3.187c60f0f68.Coremail.luyun_611@163.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------dXNjmVauvoy0tmBnxkx4nmvc
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/27/23 23:11, wo wrote:
> [  149.595642] [pid:7,cpu6,kworker/u16:0,0]BEFORE: REG_RCR differs from regrcr: 
> 0x1830613 insted of 0x7000604e
> [  160.676422] [pid:237,cpu6,kworker/u16:5,3]BEFORE: REG_RCR differs from 
> regrcr: 0x70006009 insted of 0x700060ce
 > [  327.234588] [pid:7,cpu7,kworker/u16:0,5]BEFORE: REG_RCR differs from 
regrcr: 0x1830d33 insted of 0x7000604e


My patch was messed up, but it got the information that I wanted, which is shown 
in the quoted lines above. One of these differs only in the low-order byte, 
while the other 2 are completely different. Strange!

It is possible that there is a firmware error. My system, which does not show 
the problem, reports the following:

[54130.741148] usb 3-6: RTL8192CU rev A (TSMC) romver 0, 2T2R, TX queues 2, 
WiFi=1, BT=0, GPS=0, HI PA=0
[54130.741153] usb 3-6: RTL8192CU MAC: xx:xx:xx:xx:xx:xx
[54130.741155] usb 3-6: rtl8xxxu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
[54130.742301] usb 3-6: Firmware revision 88.2 (signature 0x88c1)

Which firmware does your unit use?

Attached is a new test patch. When it logs a CORRUPTED value, I would like to 
know what task is attached to the pid listed in the message. Note that the two 
instances where the entire word was wrong came from pid:7.

Could improper locking could produce these results?

Larry

--------------dXNjmVauvoy0tmBnxkx4nmvc
Content-Type: text/x-patch; charset=UTF-8; name="log_data_2.patch"
Content-Disposition: attachment; filename="log_data_2.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUKaW5kZXggZjU1NDNlZWY0ZjgyLi42
ZDk4NWExNzVkNzggMTAwNjQ0Ci0tLSBhL01ha2VmaWxlCisrKyBiL01ha2VmaWxlCkBAIC0x
LDggKzEsOCBAQAogIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMAogVkVSU0lP
TiA9IDYKLVBBVENITEVWRUwgPSAzCitQQVRDSExFVkVMID0gNAogU1VCTEVWRUwgPSAwCi1F
WFRSQVZFUlNJT04gPQorRVhUUkFWRVJTSU9OID0gLXJjMAogTkFNRSA9IEh1cnIgZHVyciBJ
J21hIG5pbmphIHNsb3RoCiAKICMgKkRPQ1VNRU5UQVRJT04qCmRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bDh4eHh1L3J0bDh4eHh1X2NvcmUuYyBiL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsOHh4eHUvcnRsOHh4eHVfY29yZS5jCmlu
ZGV4IDgzMTYzOWQ3MzY1Ny4uOWQ3Nzg0MDBkMmI5IDEwMDY0NAotLS0gYS9kcml2ZXJzL25l
dC93aXJlbGVzcy9yZWFsdGVrL3J0bDh4eHh1L3J0bDh4eHh1X2NvcmUuYworKysgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bDh4eHh1L3J0bDh4eHh1X2NvcmUuYwpAQCAt
NDg2NCw2ICs0ODY0LDEwIEBAIHJ0bDh4eHh1X2Jzc19pbmZvX2NoYW5nZWQoc3RydWN0IGll
ZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsCiAJdTMyIHZhbDMy
OwogCXU4IHZhbDg7CiAKKwlpZiAocHJpdi0+cmVncmNyICE9IHJ0bDh4eHh1X3JlYWQzMihw
cml2LCBSRUdfUkNSKSkgeworCQlwcl9pbmZvKCJSRUdfUkNSIGNvcnJ1cHRlZCBpbiAlczog
MHgleCBpbnN0ZWQgb2YgMHgleFxuIiwKKwkJCV9fZnVuY19fLCBydGw4eHh4dV9yZWFkMzIo
cHJpdiwgUkVHX1JDUiksIHByaXYtPnJlZ3Jjcik7CisJfQogCXJhcnB0ID0gJnByaXYtPnJh
X3JlcG9ydDsKIAogCWlmIChjaGFuZ2VkICYgQlNTX0NIQU5HRURfQVNTT0MpIHsKQEAgLTY1
MDQsNiArNjUwOCwxMCBAQCBzdGF0aWMgdm9pZCBydGw4eHh4dV9jb25maWd1cmVfZmlsdGVy
KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAogCXN0cnVjdCBydGw4eHh4dV9wcml2ICpwcml2
ID0gaHctPnByaXY7CiAJdTMyIHJjciA9IHByaXYtPnJlZ3JjcjsKIAorCWlmIChwcml2LT5y
ZWdyY3IgIT0gcnRsOHh4eHVfcmVhZDMyKHByaXYsIFJFR19SQ1IpKSB7CisJCXByX2luZm8o
IlJFR19SQ1IgY29ycnVwdGVkIGluICVzOiAweCV4IGluc3RlZCBvZiAweCV4XG4iLAorCQkJ
X19mdW5jX18sIHJ0bDh4eHh1X3JlYWQzMihwcml2LCBSRUdfUkNSKSwgcHJpdi0+cmVncmNy
KTsKKwl9CiAJZGV2X2RiZygmcHJpdi0+dWRldi0+ZGV2LCAiJXM6IGNoYW5nZWRfZmxhZ3Mg
JTA4eCwgdG90YWxfZmxhZ3MgJTA4eFxuIiwKIAkJX19mdW5jX18sIGNoYW5nZWRfZmxhZ3Ms
ICp0b3RhbF9mbGFncyk7CiAK

--------------dXNjmVauvoy0tmBnxkx4nmvc--
