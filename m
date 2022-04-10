Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A294A4FB036
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 22:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242310AbiDJUpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 16:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235275AbiDJUpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 16:45:35 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A683F24F33
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 13:43:23 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id u15so8487926ejf.11
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 13:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OidQIHbEm/hM6OAnbFcQVbU0BPrg1Seqw7Y933k7iHk=;
        b=e4W65seRjaLegmIk/OvxytHviWAisj66NFs6XfVQG39KqoNOSUhXlTq6b1hnm6rgLW
         idJSXoORhzZ8Y4jYPaLZM94QqaWYf0TNcrD/kk4tS6xP4HlcEtT/w75CoW79Td6IhTcM
         W1lnAcMAwstXURXMMUkr+iX52kD8vm4aXHK5Z3Ob5dAd53zq/PVS8lIKC/gJ+nCzJXGm
         CNoRRhPANDOauAPJ+IQFm9Yh65OC5atrbj3uxvxIpsVrsf6GM6Nndop/T2c5Md9vRLHg
         rRSIx3U9rpH/NkCd83LujQtiPhUJt3LVOkyfIeZDuwQb2+/+wNIFeFCDSTx9PV84ca2s
         RIWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OidQIHbEm/hM6OAnbFcQVbU0BPrg1Seqw7Y933k7iHk=;
        b=CymFL16wsWvPAbdAQO5mnqAVus0H1a3sV3A8/0HN5UedmzpcPthnl7eQSmkgk2GaWD
         0g2lPK7LqgUfL98/5NweGExL24X74mWguG2mhkGl/BkUf4RZmKwS95/Tsu3ugxtR3Fss
         zQqgbLZlAiTLcrSGVFKdRNO5xxUJDt4kDxQR7dIAKxZ0VG7KgJIufYwuknbLR9+kCww7
         BG+DfT1/arAp2qhizycoyhXkz6ZprVTXujB33eMOe0k23RNY8oB81UTYict+H+MFThXm
         ho1vgI9cQywS5F2NVulH7vhFII6/iLJma5RLffBQfo2Y8LIEmd4EApfhaYEdJxo/47GA
         zSTQ==
X-Gm-Message-State: AOAM530VqbnJOSSb98BTcvlvzAPKuaHqxsabi7kCTqAhi2EYWZM/uyY1
        SevFlWr0VIlNDHnWLEhBswcz2CIC45ztX/Zp
X-Google-Smtp-Source: ABdhPJzM/vTuIOL3y47aOYAclLGpMU4sYPQTLdWIWN/M9l68vr5/jPDSo2tJ3RjDOtBicwhGpoI5VA==
X-Received: by 2002:a17:907:da7:b0:6df:9ff4:10c7 with SMTP id go39-20020a1709070da700b006df9ff410c7mr26771655ejc.106.1649623401832;
        Sun, 10 Apr 2022 13:43:21 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id p24-20020a056402045800b0041614c8f79asm13712479edw.88.2022.04.10.13.43.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Apr 2022 13:43:21 -0700 (PDT)
Message-ID: <b38a740f-fadb-bd2e-38d2-3683ddce69eb@blackwall.org>
Date:   Sun, 10 Apr 2022 23:43:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 0/6] net: bridge: add flush filtering support
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org, Ido Schimmel <idosch@idosch.org>
References: <20220409105857.803667-1-razor@blackwall.org>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220409105857.803667-1-razor@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/04/2022 13:58, Nikolay Aleksandrov wrote:
> Hi,
> This patch-set adds support to specify filtering conditions for a flush
> operation. Initially only FDB flush filtering is added, later MDB
> support will be added as well. Some user-space applications need a way
> to delete only a specific set of entries, e.g. mlag implementations need
> a way to flush only dynamic entries excluding externally learned ones
> or only externally learned ones without static entries etc. Also apps
> usually want to target only a specific vlan or port/vlan combination.
> The current 2 flush operations (per port and bridge-wide) are not
> extensible and cannot provide such filtering, so a new bridge af
> attribute is added (IFLA_BRIDGE_FLUSH) which contains the filtering
> information for each object type which has to be flushed.
> An example structure for fdbs:
>      [ IFLA_BRIDGE_FLUSH ]
>       `[ BRIDGE_FDB_FLUSH ]
>         `[ FDB_FLUSH_NDM_STATE ]
>         `[ FDB_FLUSH_NDM_FLAGS ]
> 
[snip]
> Note that all flags have their negated version (static vs nostatic etc)
> and there are some tricky cases to handle like "static" which in flag
> terms means fdbs that have NUD_NOARP but *not* NUD_PERMANENT, so the
> mask matches on both but we need only NUD_NOARP to be set. That's
> because permanent entries have both set so we can't just match on
> NUD_NOARP. Also note that this flush operation doesn't treat permanent
> entries in a special way (fdb_delete vs fdb_delete_local), it will
> delete them regardless if any port is using them. We can extend the api
> with a flag to do that if needed in the future.
> 
> Patches in this set:
>  1. adds the new IFLA_BRIDGE_FLUSH bridge af attribute
>  2. adds a basic structure to describe an fdb flush filter
>  3. adds fdb netlink flush call via BRIDGE_FDB_FLUSH attribute
>  4 - 6. add support for specifying various fdb fields to filter
> 
> Patch-sets (in order):
>  - Initial flush infra and fdb flush filtering (this set)
>  - iproute2 support
>  - selftests
> 
> Future work:
>  - mdb flush support
> 
> Thanks,
>  Nik
> 
> Nikolay Aleksandrov (6):
>   net: bridge: add a generic flush operation
>   net: bridge: fdb: add support for fine-grained flushing
>   net: bridge: fdb: add new nl attribute-based flush call
>   net: bridge: fdb: add support for flush filtering based on ndm flags
>     and state
>   net: bridge: fdb: add support for flush filtering based on ifindex
>   net: bridge: fdb: add support for flush filtering based on vlan id
> 
>  include/uapi/linux/if_bridge.h |  22 ++++++
>  net/bridge/br_fdb.c            | 128 +++++++++++++++++++++++++++++++--
>  net/bridge/br_netlink.c        |  59 ++++++++++++++-
>  net/bridge/br_private.h        |  12 +++-
>  net/bridge/br_sysfs_br.c       |   6 +-
>  5 files changed, 215 insertions(+), 12 deletions(-)
> 

Just FYI I plan to send v2 tomorrow with a few cleanups suggested by Ido.
Please don't apply this one, I'll wait for more feedback and will resubmit.

Thanks,
 Nik
