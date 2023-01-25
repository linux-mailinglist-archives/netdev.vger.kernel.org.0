Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA5267AD89
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 10:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbjAYJOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 04:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235073AbjAYJOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 04:14:02 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A5343466
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 01:13:59 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id c4-20020a1c3504000000b003d9e2f72093so765003wma.1
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 01:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q775n7lI1oUpACTYnypolP4ZkR2yntPGVeZ6nu77BSc=;
        b=1qiNf5SBApdx42ZoS6jJAx4GouN8OGCCSXFZurAjF2fsmRXdxVjyr3eGNAIOCFsJZE
         B9Hy5TsvwXKpklJrzdP4N0mPESdqT/bQttMZYs92dud3ehJUPCaYBX8RSdjChQ2C2iu8
         8ysMaSMGOWyKfe96xkbsHnGPrN4TbZ36xZ65Egh78d9EHBv1vly158agczy0GkRhdK/l
         5mu8+r10FwWqJQDQ0EBU5QBfjw5+Z07f/uiIdEFs1MpiBtC1DsMKuCY+sB4f1mRigSFc
         su5GtBghguL7enfqaBV848vvU+aHr91JeK70YXgH+Rdfm9UPuxv4fjFPFFScGHxR/N2d
         ld6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=q775n7lI1oUpACTYnypolP4ZkR2yntPGVeZ6nu77BSc=;
        b=ZvM3ilU3D6eAMJbVnFOXIZ9CgdeLJDZGpnRH5CBkeDCT6QSXgdtZNHTELN5HnsezCJ
         y2cOa7+LMlA+N+hdfq/OzH4VOMNkCxqZC1qMsucuaAJ+LOneB1kEdcMCNc7LvHfldRnt
         zr0uLRQSJYuRlzh+4UaypyTKDTGmMppvtOVMirMS1NqZpbp/nkMjNgsf884qgf13JZ0P
         wXowqxQa5WDrR4u4Z/gmksG7Ef9YO8i1QVfLe5AJ+teutWirnfvdLCU3hVsE2RAoytOy
         ql8oicpPPZ0xxYzUZTyXd7HZpmpEXMHQGBfCsu5e5FEyTmgWDq99F7kNQmusHAyHIE1O
         7qIQ==
X-Gm-Message-State: AFqh2krSAWS9eGY3+ewupb+85rkt/CAmWVW2/8oxPEMKkInLeu7CF5CX
        T90Xu9mhk74dK2XeVyhjwStB9w==
X-Google-Smtp-Source: AMrXdXuFPgf/COhHo53ZBYrEua4s31BsqBmw9x0HweSVWKF9NdI9I1lc+TUQ1L4nsCtb0btMQoipmg==
X-Received: by 2002:a7b:c4d7:0:b0:3db:2fc6:e124 with SMTP id g23-20020a7bc4d7000000b003db2fc6e124mr20185668wmk.7.1674638037867;
        Wed, 25 Jan 2023 01:13:57 -0800 (PST)
Received: from [192.168.3.222] (213.211.137.183.static.edpnet.net. [213.211.137.183])
        by smtp.gmail.com with ESMTPSA id u11-20020a05600c19cb00b003d9fb04f658sm1338362wmq.4.2023.01.25.01.13.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jan 2023 01:13:57 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------UsMGKrEG9gR21P0caSvP0Ns7"
Message-ID: <d36076f3-6add-a442-6d4b-ead9f7ffff86@tessares.net>
Date:   Wed, 25 Jan 2023 10:13:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH net 0/4] Netfilter fixes for net: manual merge
Content-Language: en-GB
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
        Florian Westphal <fw@strlen.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
References: <20230124183933.4752-1-pablo@netfilter.org>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20230124183933.4752-1-pablo@netfilter.org>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------UsMGKrEG9gR21P0caSvP0Ns7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

On 24/01/2023 19:39, Pablo Neira Ayuso wrote:
> Hi,
> 
> The following patchset contains Netfilter fixes for net:

(...)

> Sriram Yagnaraman (4):
>       netfilter: conntrack: fix vtag checks for ABORT/SHUTDOWN_COMPLETE
>       netfilter: conntrack: fix bug in for_each_sctp_chunk
>       Revert "netfilter: conntrack: add sctp DATA_SENT state"
>       netfilter: conntrack: unify established states for SCTP paths

FYI, we got a small conflict when merging -net in net-next in the MPTCP
tree due to the last two patches applied in -net:

  13bd9b31a969 ("Revert "netfilter: conntrack: add sctp DATA_SENT state"")
  a44b7651489f ("netfilter: conntrack: unify established states for SCTP
paths")

and this one from net-next:

  f71cb8f45d09 ("netfilter: conntrack: sctp: use nf log infrastructure
for invalid packets")

The conflict has been resolved on our side[1] and the resolution we
suggest is attached to this email.

Cheers,
Matt

[1] https://github.com/multipath-tcp/mptcp_net-next/commit/4e2bc066dae4
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
--------------UsMGKrEG9gR21P0caSvP0Ns7
Content-Type: text/x-patch; charset=UTF-8;
 name="4e2bc066dae4fc2fb7dbb0172c5dd3b56bc26bc8.patch"
Content-Disposition: attachment;
 filename="4e2bc066dae4fc2fb7dbb0172c5dd3b56bc26bc8.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWNjIG5ldC9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3Byb3RvX3NjdHAuYwppbmRl
eCBkYmRmY2M2Y2QyYWEsOTQ1ZGQ0MGU3MDc3Li4zOTM3Y2JlZTk0MTgKLS0tIGEvbmV0L25l
dGZpbHRlci9uZl9jb25udHJhY2tfcHJvdG9fc2N0cC5jCisrKyBiL25ldC9uZXRmaWx0ZXIv
bmZfY29ubnRyYWNrX3Byb3RvX3NjdHAuYwpAQEAgLTI0MywxNiAtMjM4LDE0ICsyMjcsMTIg
QEBAIHN0YXRpYyBpbnQgc2N0cF9uZXdfc3RhdGUoZW51bSBpcF9jb25udAogIAkJaSA9IDk7
CiAgCQlicmVhazsKICAJY2FzZSBTQ1RQX0NJRF9IRUFSVEJFQVRfQUNLOgogLQkJcHJfZGVi
dWcoIlNDVFBfQ0lEX0hFQVJUQkVBVF9BQ0siKTsKICAJCWkgPSAxMDsKICAJCWJyZWFrOwot
IAljYXNlIFNDVFBfQ0lEX0RBVEE6Ci0gCWNhc2UgU0NUUF9DSURfU0FDSzoKLSAJCWkgPSAx
MTsKLSAJCWJyZWFrOwogIAlkZWZhdWx0OgogIAkJLyogT3RoZXIgY2h1bmtzIGxpa2UgREFU
QSBvciBTQUNLIGRvIG5vdCBjaGFuZ2UgdGhlIHN0YXRlICovCiAtCQlwcl9kZWJ1ZygiVW5r
bm93biBjaHVuayB0eXBlLCBXaWxsIHN0YXkgaW4gJXNcbiIsCiAtCQkJIHNjdHBfY29ubnRy
YWNrX25hbWVzW2N1cl9zdGF0ZV0pOwogKwkJcHJfZGVidWcoIlVua25vd24gY2h1bmsgdHlw
ZSAlZCwgV2lsbCBzdGF5IGluICVzXG4iLAogKwkJCSBjaHVua190eXBlLCBzY3RwX2Nvbm50
cmFja19uYW1lc1tjdXJfc3RhdGVdKTsKICAJCXJldHVybiBjdXJfc3RhdGU7CiAgCX0KICAK
QEBAIC0zODYsMjEgLTM4MSwxOSArMzY0LDIxIEBAQCBpbnQgbmZfY29ubnRyYWNrX3NjdHBf
cGFja2V0KHN0cnVjdCBuZl8KICAKICAJCWlmICghc2N0cF9uZXcoY3QsIHNrYiwgc2gsIGRh
dGFvZmYpKQogIAkJCXJldHVybiAtTkZfQUNDRVBUOwotIAl9IGVsc2UgewotIAkJLyogQ2hl
Y2sgdGhlIHZlcmlmaWNhdGlvbiB0YWcgKFNlYyA4LjUpICovCi0gCQlpZiAoIXRlc3RfYml0
KFNDVFBfQ0lEX0lOSVQsIG1hcCkgJiYKLSAJCSAgICAhdGVzdF9iaXQoU0NUUF9DSURfU0hV
VERPV05fQ09NUExFVEUsIG1hcCkgJiYKLSAJCSAgICAhdGVzdF9iaXQoU0NUUF9DSURfQ09P
S0lFX0VDSE8sIG1hcCkgJiYKLSAJCSAgICAhdGVzdF9iaXQoU0NUUF9DSURfQUJPUlQsIG1h
cCkgJiYKLSAJCSAgICAhdGVzdF9iaXQoU0NUUF9DSURfU0hVVERPV05fQUNLLCBtYXApICYm
Ci0gCQkgICAgIXRlc3RfYml0KFNDVFBfQ0lEX0hFQVJUQkVBVCwgbWFwKSAmJgotIAkJICAg
ICF0ZXN0X2JpdChTQ1RQX0NJRF9IRUFSVEJFQVRfQUNLLCBtYXApICYmCi0gCQkgICAgc2gt
PnZ0YWcgIT0gY3QtPnByb3RvLnNjdHAudnRhZ1tkaXJdKSB7Ci0gCQkJbmZfY3RfbDRwcm90
b19sb2dfaW52YWxpZChza2IsIGN0LCBzdGF0ZSwKLSAJCQkJCQkgICJ2ZXJpZmljYXRpb24g
dGFnIGNoZWNrIGZhaWxlZCAleCB2cyAleCBmb3IgZGlyICVkIiwKLSAJCQkJCQkgIHNoLT52
dGFnLCBjdC0+cHJvdG8uc2N0cC52dGFnW2Rpcl0sIGRpcik7Ci0gCQkJZ290byBvdXQ7Ci0g
CQl9CisgCX0KKyAKKyAJLyogQ2hlY2sgdGhlIHZlcmlmaWNhdGlvbiB0YWcgKFNlYyA4LjUp
ICovCisgCWlmICghdGVzdF9iaXQoU0NUUF9DSURfSU5JVCwgbWFwKSAmJgorIAkgICAgIXRl
c3RfYml0KFNDVFBfQ0lEX1NIVVRET1dOX0NPTVBMRVRFLCBtYXApICYmCisgCSAgICAhdGVz
dF9iaXQoU0NUUF9DSURfQ09PS0lFX0VDSE8sIG1hcCkgJiYKKyAJICAgICF0ZXN0X2JpdChT
Q1RQX0NJRF9BQk9SVCwgbWFwKSAmJgorIAkgICAgIXRlc3RfYml0KFNDVFBfQ0lEX1NIVVRE
T1dOX0FDSywgbWFwKSAmJgorIAkgICAgIXRlc3RfYml0KFNDVFBfQ0lEX0hFQVJUQkVBVCwg
bWFwKSAmJgorIAkgICAgIXRlc3RfYml0KFNDVFBfQ0lEX0hFQVJUQkVBVF9BQ0ssIG1hcCkg
JiYKKyAJICAgIHNoLT52dGFnICE9IGN0LT5wcm90by5zY3RwLnZ0YWdbZGlyXSkgewogLQkJ
cHJfZGVidWcoIlZlcmlmaWNhdGlvbiB0YWcgY2hlY2sgZmFpbGVkXG4iKTsKKysJCW5mX2N0
X2w0cHJvdG9fbG9nX2ludmFsaWQoc2tiLCBjdCwgc3RhdGUsCisrCQkJCQkgICJ2ZXJpZmlj
YXRpb24gdGFnIGNoZWNrIGZhaWxlZCAleCB2cyAleCBmb3IgZGlyICVkIiwKKysJCQkJCSAg
c2gtPnZ0YWcsIGN0LT5wcm90by5zY3RwLnZ0YWdbZGlyXSwgZGlyKTsKKyAJCWdvdG8gb3V0
OwogIAl9CiAgCiAgCW9sZF9zdGF0ZSA9IG5ld19zdGF0ZSA9IFNDVFBfQ09OTlRSQUNLX05P
TkU7Cg==

--------------UsMGKrEG9gR21P0caSvP0Ns7--
