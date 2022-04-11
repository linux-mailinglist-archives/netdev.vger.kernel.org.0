Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBF694FC39B
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 19:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239275AbiDKRpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 13:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235152AbiDKRpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 13:45:10 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19C3220FE
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 10:42:54 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bh17so32386957ejb.8
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 10:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Qn0m42DURCvgyA+3fQ3KmY2jO1hPwl7SsCJTQkfJV1s=;
        b=hMkj2kvMUd7imAmQLdIxKRb5Y6stYgX2688k9Otvb5DuBuGpKEVIzX2kLC0il0bbuC
         Dxg8JbTm4UWxbe/cvYxUsKKiAq9QEEvmvHMKr7WnRrnIEf3kz9qvX1sPKAQW45TVLtuo
         fP7XB81maT1NwKW4v3GZ+j2t29xaKL8mD/u4X7aMrGAfrSiz9ha6Mv5ywKLv3sRWrOyq
         Ou/uXdcDhayTAVeJLZkyHql3VVGDXBNGZ4O2vP9fb5SxgaI9qXBg1noS+UbhEC+UQKF8
         PMw3KVI33DheavQ7MDCthvZxpI4Q1hV0sKBug/5/3H5tSnyZVIXZ+fzHE7oAlN120maL
         6/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Qn0m42DURCvgyA+3fQ3KmY2jO1hPwl7SsCJTQkfJV1s=;
        b=YCJIF8vcXOH+2CdmRnyDOE/q2eDVGPKuNRINWEUhq9iQCbiOqCauGQwydYhJJs/t/j
         60qkqelapdE1GAGZsCo8O5K8I4pU56BzSli9tW8xporwdHe4xa6MOMzDw3Zbr5/TvJmb
         /xQnCPMNq2vvvTna1cMCF20PCNjqbQm2INqpL7ZoI87n3aiT1EWPY9lwgrHxKAh+HYHG
         Apftad27KNo4FYf2wfAXFggQYfTbMNgFnCy8Jix5CJaDOHF7t1cTi0UREVp1kMeVhczq
         r4P5w3pNKOGpQKATSP3TR2Y3LjIMfkYcn4soMhZyuFZ1ohckLBh2yXD5If3eIUNwXTsT
         Qz9g==
X-Gm-Message-State: AOAM531HRrS589cAtEKXU8bGyAE70y2qrEniXe1+PGdsHmv7wXYhgwVg
        ecRfaAK72khHFO9Cmj7HqlRxX1FXuBWVNXxG
X-Google-Smtp-Source: ABdhPJxSlTBZucy+uuY8OR6pUuEslmh0PoObVjfwbfegrQwnWuOG8zmj7amgAJNB0D2XbOJZxJefjA==
X-Received: by 2002:a17:907:7f1b:b0:6e8:558c:5ba with SMTP id qf27-20020a1709077f1b00b006e8558c05bamr15442310ejc.522.1649698973189;
        Mon, 11 Apr 2022 10:42:53 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id sh31-20020a1709076e9f00b006e8289e5836sm5977052ejc.117.2022.04.11.10.42.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 10:42:52 -0700 (PDT)
Message-ID: <e3655cbf-5b8f-85d1-cd5f-80df739d79f4@blackwall.org>
Date:   Mon, 11 Apr 2022 20:42:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v2 0/8] net: bridge: add flush filtering support
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, idosch@idosch.org, kuba@kernel.org,
        davem@davemloft.net, bridge@lists.linux-foundation.org
References: <20220411172934.1813604-1-razor@blackwall.org>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220411172934.1813604-1-razor@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/04/2022 20:29, Nikolay Aleksandrov wrote:
> Hi,
> This patch-set adds support to specify filtering conditions for a flush
> operation. This version has entirely different entry point (v1 had
> bridge-specific IFLA attribute, here I add new RTM_FLUSHNEIGH msg and
> netdev ndo_fdb_flush op) so I'll give a new overview altogether.
> After me and Ido discussed the feature offlist, we agreed that it would
> be best to add a new generic RTM_FLUSHNEIGH with a new ndo_fdb_flush
> callback which can be re-used for other drivers (e.g. vxlan).
> Patch 01 adds the new RTM_FLUSHNEIGH type, patch 02 then adds the
> new ndo_fdb_flush call. With this structure we need to add a generic
> rtnl_fdb_flush which will be used to do basic attribute validation and
> dispatch the call to the appropriate device based on the NTF_USE/MASTER
> flags (patch 03). Patch 04 then adds some common flush attributes which
> are used by the bridge and vxlan drivers (target ifindex, vlan id, ndm
> flags/state masks) with basic attribute validation, further validation
> can be done by the implementers of the ndo callback. Patch 05 adds a
> minimal ndo_fdb_flush to the bridge driver, it uses the current
> br_fdb_flush implementation to flush all entries similar to existing
> calls. Patch 06 adds filtering support to the new bridge flush op which
> supports target ifindex (port or bridge), vlan id and flags/state mask.
> Patch 07 converts ndm state/flags and their masks to bridge-private flags
> and fills them in the filter descriptor for matching. Finally patch 08

Aargh.. I mixed up the patch numbers above. Patch 03 adds the minimal ndo_fdb_flush
to the bridge driver (not patch 05), patch 04 adds the generic rtnl_fdb_flush
(not patch 03) and patch 05 adds the common attributes (not patch 04).

Let me know if you'd like me to repost it with fixed numbers. I'll wait for
feedback anyway.

> fills in the target ifindex (after validating it) and vlan id (already
> validated by rtnl_fdb_flush) for matching. Flush filtering is needed> because user-space applications need a quick way to delete only a
> specific set of entries, e.g. mlag implementations need a way to flush only
> dynamic entries excluding externally learned ones or only externally
> learned ones without static entries etc. Also apps usually want to target
> only a specific vlan or port/vlan combination. The current 2 flush
> operations (per port and bridge-wide) are not extensible and cannot
> provide such filtering.



