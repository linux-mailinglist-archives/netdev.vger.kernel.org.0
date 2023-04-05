Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A876D7D76
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 15:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237221AbjDENNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 09:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237218AbjDENNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 09:13:07 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDE7171F
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 06:13:03 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id p34so20855711wms.3
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 06:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1680700382;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vNzCqRY1oZU1JbrORYUrLkQuB+gPG/h4L0AC8XHO9kU=;
        b=dEnXU5fO8WSr2mycjTGgUd4XyqXV0ApnQCTK803awH65Tx+7EllzggNBnIveobwefF
         5fLHM80ae3RGkTsK/n6iRkT/kWuY2JrKrrDnUtMceXufsjL32pxPj6pQ0UjPclBOOuXO
         R0g2sYbv1KAkKZo9fjBw/aYXezILDTkf2SazmwITfmzi9RJS6RnQN4GprOjKjJzYwjRY
         j8BNXKD01J40RkE1ro0Ok7f+nHpL+ryTBO6iXeyOR+keP9/DTjyEMOf8ICj2KB+4etjl
         8ARkHX8CcjlsY7/HNrDNTlqHGz76RhzXfgAy8FdrTi7Uh5VZ61s3rDBPVCWKgqtv6bkR
         S/9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680700382;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vNzCqRY1oZU1JbrORYUrLkQuB+gPG/h4L0AC8XHO9kU=;
        b=Kvgaqkq22ZPXFOIIdhucEHzM11Tn87Rqn3jlrUaVXtVYVnstiIYWDpc4wT9upaJ/Qq
         kwM3BXQA84oVGU9ohoaCIkfVqn/G+ARpSNVGqifHck5oWgb9rp+asJCjqdQn6pe/I0t2
         Y9h1IketaAC9rGd4m9btRZb1P4HpD3PI8RmHxca1ZgSUQmpAnsNvHJfvegr/1DOB+4lG
         6I0FgiffamrKKxmIlZheMp1lexp2aeNGs+qtLV0Sjzj3OaQCLOXS2Szq1qNX0rAd2IQK
         xHh47F9yNE93OpxxAKHTRh58vLQIGZmwT7pCem6EQn/PcV+quSOulsvYSbpmeSKpvyJU
         aqLA==
X-Gm-Message-State: AAQBX9cEh7AcNaB3+keL2Vb8NMLIJGcDWwExvxFvy1CyzDggXNnRPBxP
        59CVWqIqR4dIk+tbCUU8mKenYaLNnjelK+RzDQ+3cmZq
X-Google-Smtp-Source: AKy350bFtuBSNejcuVbgom+HcWIqsRC+v8SFnaz9PxD6zQSMK0qFgyFg7N+1/4elyzQ4Vnfyu1dQ6g==
X-Received: by 2002:a7b:c4c6:0:b0:3ed:5a12:5641 with SMTP id g6-20020a7bc4c6000000b003ed5a125641mr4636724wmk.36.1680700382246;
        Wed, 05 Apr 2023 06:13:02 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:e35b:475e:3d7f:5843? ([2a02:578:8593:1200:e35b:475e:3d7f:5843])
        by smtp.gmail.com with ESMTPSA id n19-20020a7bcbd3000000b003eae73f0fc1sm2175356wmi.18.2023.04.05.06.13.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 06:13:01 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------s0bqkphGMolVar6IcbGgo030"
Message-ID: <c5872985-1a95-0bc8-9dcc-b6f23b439e9d@tessares.net>
Date:   Wed, 5 Apr 2023 15:13:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net v2] gve: Secure enough bytes in the first TX desc for
 all TCP pkts: manual merge
Content-Language: en-GB
To:     Shailend Chand <shailend@google.com>, netdev@vger.kernel.org,
        Praveen Kaligineedi <pkaligineedi@google.com>,
        Jeroen de Borst <jeroendb@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <20230403172809.2939306-1-shailend@google.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20230403172809.2939306-1-shailend@google.com>
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------s0bqkphGMolVar6IcbGgo030
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

On 03/04/2023 19:28, Shailend Chand wrote:
> Non-GSO TCP packets whose SKBs' linear portion did not include the
> entire TCP header were not populating the first Tx descriptor with
> as many bytes as the vNIC expected. This change ensures that all
> TCP packets populate the first descriptor with the correct number of
> bytes.
> 
> Fixes: 893ce44df565 ("gve: Add basic driver framework for Compute Engine Virtual NIC")
> Signed-off-by: Shailend Chand <shailend@google.com>

FYI, we got a small conflict when merging 'net' in 'net-next' in the
MPTCP tree due to this patch applied in 'net':

  3ce934558097 ("gve: Secure enough bytes in the first TX desc for all
TCP pkts")

and this one from 'net-next':

  75eaae158b1b ("gve: Add XDP DROP and TX support for GQI-QPL format")

----- Generic Message -----
The best is to avoid conflicts between 'net' and 'net-next' trees but if
they cannot be avoided when preparing patches, a note about how to fix
them is much appreciated.

The conflict has been resolved on our side[1] and the resolution we
suggest is attached to this email. Please report any issues linked to
this conflict resolution as it might be used by others. If you worked on
the mentioned patches, don't hesitate to ACK this conflict resolution.
---------------------------

Regarding this conflict, the new "define"'s have been kept. Note that
now, two "define"'s have the same value (182) but used in different
contexts. Maybe someone will want to create a new patch to merge them.

Cheers,
Matt

[1] https://github.com/multipath-tcp/mptcp_net-next/commit/5ea299ff55b5
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
--------------s0bqkphGMolVar6IcbGgo030
Content-Type: text/x-patch; charset=UTF-8;
 name="5ea299ff55b5faad53889293c5d3e918deb456c6.patch"
Content-Disposition: attachment;
 filename="5ea299ff55b5faad53889293c5d3e918deb456c6.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWNjIGRyaXZlcnMvbmV0L2V0aGVybmV0L2dvb2dsZS9ndmUvZ3ZlLmgKaW5kZXgg
ZTIxNGI1MWQzYzhiLDAwNWNiOWRmZTA3OC4uNGI5NWY2ZTlhNDYxCi0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2dvb2dsZS9ndmUvZ3ZlLmgKKysrIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvZ29vZ2xlL2d2ZS9ndmUuaApAQEAgLTQ3LDEwIC00Nyw4ICs0NywxMiBAQEAKICAKICAj
ZGVmaW5lIEdWRV9SWF9CVUZGRVJfU0laRV9EUU8gMjA0OAogIAorICNkZWZpbmUgR1ZFX0dR
X1RYX01JTl9QS1RfREVTQ19CWVRFUyAxODIKKyAKICsjZGVmaW5lIEdWRV9YRFBfQUNUSU9O
UyA1CiArCiArI2RlZmluZSBHVkVfVFhfTUFYX0hFQURFUl9TSVpFIDE4MgogKwogIC8qIEVh
Y2ggc2xvdCBpbiB0aGUgZGVzYyByaW5nIGhhcyBhIDE6MSBtYXBwaW5nIHRvIGEgc2xvdCBp
biB0aGUgZGF0YSByaW5nICovCiAgc3RydWN0IGd2ZV9yeF9kZXNjX3F1ZXVlIHsKICAJc3Ry
dWN0IGd2ZV9yeF9kZXNjICpkZXNjX3Jpbmc7IC8qIHRoZSBkZXNjcmlwdG9yIHJpbmcgKi8K


--------------s0bqkphGMolVar6IcbGgo030--
