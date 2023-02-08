Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE6F68ECCF
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 11:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbjBHK20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 05:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjBHK2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 05:28:20 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F30946D4C
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 02:28:17 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id bg26so13001210wmb.0
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 02:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BZ1dWC1byNAQOjBdAUAnKEJBqZ0AdL70cH56TWXyx2Y=;
        b=LzNEhjgJu/8oOcBmBCacbwl/SqMdoG1Zi01G2zAk+NhTQHM7fQ65bnFg1YhpJD8ASv
         ktrqNSkBo3aimuUU7QRRU/NAebbSJcUQq/pEQhgsPADaF4iQ0DTWATUI1wHsXcR+Xdax
         hBrKPwyNewAqNbIF5cBLo97qD/eu3thJGnTVV2udZZp/iX1WJpBzVxnneEL6I1xcbR7R
         8E6955GCWNIWIcaMIr7WHSoaszeQUTCTAgzKnx9qu5VHfpsWElHtZ/nNmQTenD9pZ0dq
         2aM4meCFnv1CoyUWCSDsyd8PpFZ7h087yvlvCR5HWA6g7fXEUeDaBMypyQBsiKIDaP8h
         8taA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BZ1dWC1byNAQOjBdAUAnKEJBqZ0AdL70cH56TWXyx2Y=;
        b=xrLL3A2PRSHvXqjPn/P6Yu/1oDiiDSAvCz+Qt8GqfvfEw3z2kS3OLdILBQbWgZJeof
         tlwMlVyh7vfvuBqGc+EJUeK5AYxNAgG4P061S3sY8ebDzy5leDrK+ARJ5XsUI76qm3/T
         gP40UIrUvejYvxEB8vmW4bDp68VigogRJoeLB59QF4CyfsyQzaSLOOSlBpWDJ6Pn6ha6
         MY8IxU1C0nRnVB02fhnzgXBTGcyZbN3ngA1U1mFCR+StbuB3s8DGygHsk4eGmNTRCAqu
         SDedhragn58e0DPSJWCgqKq5K3RYhjnmvD2ehVTksyspRdksqeD3UKXQgLCxpx/mshUb
         GjVg==
X-Gm-Message-State: AO0yUKVRMTFPiSvQv2Ba+11dIm1dcFShjGVD9yZ/AwJte83wRRLG/R8c
        RpfXCqhaX3icKtq2UQRyPyBXF13NZLnYb81FYmzvfw==
X-Google-Smtp-Source: AK7set/GRn/4bHjkYEzWxRB3qG08sdIy1P5B+57Mx2QgJiO6QX7OpgojPZGQjzDGDTfunc5otA3QPg==
X-Received: by 2002:a05:600c:810:b0:3df:f7e7:5f01 with SMTP id k16-20020a05600c081000b003dff7e75f01mr5956834wmp.15.1675852096468;
        Wed, 08 Feb 2023 02:28:16 -0800 (PST)
Received: from ?IPV6:2a02:578:8593:1200:5794:f85b:a7dd:b36? ([2a02:578:8593:1200:5794:f85b:a7dd:b36])
        by smtp.gmail.com with ESMTPSA id d5-20020a1c7305000000b003dc4baaedd3sm1423345wmb.37.2023.02.08.02.28.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 02:28:16 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------am4rv3xJJnsfFj0Y66TcgcCp"
Message-ID: <fab48356-3f31-2365-81b8-fc3734db273d@tessares.net>
Date:   Wed, 8 Feb 2023 11:28:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Content-Language: en-GB
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20230208094657.379f2b1a@canb.auug.org.au>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20230208094657.379f2b1a@canb.auug.org.au>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------am4rv3xJJnsfFj0Y66TcgcCp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Stephen,

On 07/02/2023 23:46, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in:
> 
>   net/devlink/leftover.c (net/core/devlink.c in the net tree)
> 
> between commit:
> 
>   565b4824c39f ("devlink: change port event netdev notifier from per-net to global")
> 
> from the net tree and commits:
> 
>   f05bd8ebeb69 ("devlink: move code to a dedicated directory")
>   687125b5799c ("devlink: split out core code")
> 
> from the net-next tree.
> 
> I fixed it up (I used the latter version of this file and applied the
> following merge fix up) and can carry the fix as necessary.

Thank you for the fix!

I also had the same conflicts on MPTCP side when merging mptcp-next with
-net and I used the same resolution:

Tested-by: Matthieu Baerts <matthieu.baerts@tessares.net>

I was just a bit confused because I didn't see the modifications in
net/devlink/leftover.c -- devlink_port_netdevice_event() function -- in
the patch you attached but I saw them on linux-next. I guess that's
because you used the latter version of this file.

Just in case it would help the net maintainers, I attached to this email
the modification I had on my side which looks the same as Jiri's
original patch but using the new paths.

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
--------------am4rv3xJJnsfFj0Y66TcgcCp
Content-Type: text/x-patch; charset=UTF-8;
 name="d5f649fee1672d3d077610dd4878d49be18debaf.patch"
Content-Disposition: attachment;
 filename="d5f649fee1672d3d077610dd4878d49be18debaf.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL25ldC9kZXZsaW5rL2NvcmUuYyBiL25ldC9kZXZsaW5rL2NvcmUuYwpp
bmRleCBhZWZmZDFiODIwNmQuLmE0ZjQ3ZGFmYjg2NCAxMDA2NDQKLS0tIGEvbmV0L2Rldmxp
bmsvY29yZS5jCisrKyBiL25ldC9kZXZsaW5rL2NvcmUuYwpAQCAtMjA1LDcgKzIwNSw3IEBA
IHN0cnVjdCBkZXZsaW5rICpkZXZsaW5rX2FsbG9jX25zKGNvbnN0IHN0cnVjdCBkZXZsaW5r
X29wcyAqb3BzLAogCQlnb3RvIGVycl94YV9hbGxvYzsKIAogCWRldmxpbmstPm5ldGRldmlj
ZV9uYi5ub3RpZmllcl9jYWxsID0gZGV2bGlua19wb3J0X25ldGRldmljZV9ldmVudDsKLQly
ZXQgPSByZWdpc3Rlcl9uZXRkZXZpY2Vfbm90aWZpZXJfbmV0KG5ldCwgJmRldmxpbmstPm5l
dGRldmljZV9uYik7CisJcmV0ID0gcmVnaXN0ZXJfbmV0ZGV2aWNlX25vdGlmaWVyKCZkZXZs
aW5rLT5uZXRkZXZpY2VfbmIpOwogCWlmIChyZXQpCiAJCWdvdG8gZXJyX3JlZ2lzdGVyX25l
dGRldmljZV9ub3RpZmllcjsKIApAQCAtMjY2LDggKzI2Niw3IEBAIHZvaWQgZGV2bGlua19m
cmVlKHN0cnVjdCBkZXZsaW5rICpkZXZsaW5rKQogCXhhX2Rlc3Ryb3koJmRldmxpbmstPnNu
YXBzaG90X2lkcyk7CiAJeGFfZGVzdHJveSgmZGV2bGluay0+cG9ydHMpOwogCi0JV0FSTl9P
Tl9PTkNFKHVucmVnaXN0ZXJfbmV0ZGV2aWNlX25vdGlmaWVyX25ldChkZXZsaW5rX25ldChk
ZXZsaW5rKSwKLQkJCQkJCSAgICAgICAmZGV2bGluay0+bmV0ZGV2aWNlX25iKSk7CisJV0FS
Tl9PTl9PTkNFKHVucmVnaXN0ZXJfbmV0ZGV2aWNlX25vdGlmaWVyKCZkZXZsaW5rLT5uZXRk
ZXZpY2VfbmIpKTsKIAogCXhhX2VyYXNlKCZkZXZsaW5rcywgZGV2bGluay0+aW5kZXgpOwog
CmRpZmYgLS1naXQgYS9uZXQvZGV2bGluay9sZWZ0b3Zlci5jIGIvbmV0L2RldmxpbmsvbGVm
dG92ZXIuYwppbmRleCA5ZDYzNzM2MDMzNDAuLmYwNWFiMDkzZDIzMSAxMDA2NDQKLS0tIGEv
bmV0L2RldmxpbmsvbGVmdG92ZXIuYworKysgYi9uZXQvZGV2bGluay9sZWZ0b3Zlci5jCkBA
IC04NDMwLDYgKzg0MzAsOCBAQCBpbnQgZGV2bGlua19wb3J0X25ldGRldmljZV9ldmVudChz
dHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5iLAogCQlicmVhazsKIAljYXNlIE5FVERFVl9SRUdJ
U1RFUjoKIAljYXNlIE5FVERFVl9DSEFOR0VOQU1FOgorCQlpZiAoZGV2bGlua19uZXQoZGV2
bGluaykgIT0gZGV2X25ldChuZXRkZXYpKQorCQkJcmV0dXJuIE5PVElGWV9PSzsKIAkJLyog
U2V0IHRoZSBuZXRkZXYgb24gdG9wIG9mIHByZXZpb3VzbHkgc2V0IHR5cGUuIE5vdGUgdGhp
cwogCQkgKiBldmVudCBoYXBwZW5zIGFsc28gZHVyaW5nIG5ldCBuYW1lc3BhY2UgY2hhbmdl
IHNvIGhlcmUKIAkJICogd2UgdGFrZSBpbnRvIGFjY291bnQgbmV0ZGV2IHBvaW50ZXIgYXBw
ZWFyaW5nIGluIHRoaXMKQEAgLTg0MzksNiArODQ0MSw4IEBAIGludCBkZXZsaW5rX3BvcnRf
bmV0ZGV2aWNlX2V2ZW50KHN0cnVjdCBub3RpZmllcl9ibG9jayAqbmIsCiAJCQkJCW5ldGRl
dik7CiAJCWJyZWFrOwogCWNhc2UgTkVUREVWX1VOUkVHSVNURVI6CisJCWlmIChkZXZsaW5r
X25ldChkZXZsaW5rKSAhPSBkZXZfbmV0KG5ldGRldikpCisJCQlyZXR1cm4gTk9USUZZX09L
OwogCQkvKiBDbGVhciBuZXRkZXYgcG9pbnRlciwgYnV0IG5vdCB0aGUgdHlwZS4gVGhpcyBl
dmVudCBoYXBwZW5zCiAJCSAqIGFsc28gZHVyaW5nIG5ldCBuYW1lc3BhY2UgY2hhbmdlIHNv
IHdlIG5lZWQgdG8gY2xlYXIKIAkJICogcG9pbnRlciB0byBuZXRkZXYgdGhhdCBpcyBnb2lu
ZyB0byBhbm90aGVyIG5ldCBuYW1lc3BhY2UuCg==

--------------am4rv3xJJnsfFj0Y66TcgcCp--
