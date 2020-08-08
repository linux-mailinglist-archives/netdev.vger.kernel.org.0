Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAA723F81E
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 17:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgHHP7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 11:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbgHHP7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 11:59:40 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A7CC061756;
        Sat,  8 Aug 2020 08:59:40 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id j7so4870843oij.9;
        Sat, 08 Aug 2020 08:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7dfDkqe0MohgZmH8uj4bGL4bJvNG2hnoF5m4hePOOcw=;
        b=P24hH7Czrfi8mHom3UkoX8dd+bd6tG762PbSgVCnjlHykp4xlqR6xJFmV/5x2/wYSO
         eNYzMDglpolZLyilCmOvuGWGHLw2wcsvi9E2GhKZU64yyoS/QYdp3Z5+Pm/fjiwICn4U
         SmMSih8lnl8PjKaFJnKf8fV0NbQ+NlAyhETCEpRMnE2GvMWt8AOtxbGL9p57Npb4VTAf
         ZfQ2G0fciNlm6vBNrNUmQWnfvIr48pb0mJxKJwKnuQRg5HnVP8rDq0hMNaUs2e7DTNFF
         y+hlLnpJ9x86ttnUEL6P4n8GkfYYdS+4+VFTKJkUSlQad64dzqyuD5kI7u6OuqcDEgY1
         BWjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7dfDkqe0MohgZmH8uj4bGL4bJvNG2hnoF5m4hePOOcw=;
        b=VCyya8d712XHkePFmjUxfV5cCN00Uhl48R3BMHFSIjFqfiFxfALWJE0m6s11T3QjTn
         egr94nSbc28A3zf0Nsro/uDYcRv3c6G7ocS2LKKoLnjG0q8G95QR26Kk5mBgqQcapa1Q
         2yq8rLs3dR0RgDiUBQyEZ2qjabJmEL2XDBYS5TS2yCd2/mLTTBTdPv6DtEkuuDzB6Dsl
         L0H+eIg1OuP6hqVqy0XZJUBUPM3/KYd+W9BjUowFRiARLZa6TioVj28dNHjq0Tgiw7vP
         bnN1horZCrEKlsypOTpmkIuwLjjlN4RT+W63uSVf/xEsETmUvBBqsRF0+2EAKaxH7cVl
         X//A==
X-Gm-Message-State: AOAM530107+EeuyLw4UNkTKdqFmWmMpwPguBocyqSvJEiaESTdM6/HOM
        azNH0Ku5atsxZ6EOmTMuFog=
X-Google-Smtp-Source: ABdhPJymGhqPMQv0DitcITw4drSE2nmsiPaqGWl4u+UiEKPwMQO6DERlcaNl0E0OHtW6j9oT+0b5ow==
X-Received: by 2002:aca:5489:: with SMTP id i131mr16232449oib.157.1596902379287;
        Sat, 08 Aug 2020 08:59:39 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:2d6d:708e:ac93:f86b])
        by smtp.googlemail.com with ESMTPSA id e18sm1646009oiy.52.2020.08.08.08.59.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2020 08:59:38 -0700 (PDT)
Subject: Re: [RFC PATCH 0/7] metricfs metric file system and examples
To:     Andrew Lunn <andrew@lunn.ch>, Jonathan Adams <jwadams@google.com>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>
References: <20200807212916.2883031-1-jwadams@google.com>
 <20200808020617.GD2028541@lunn.ch>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <191cb2fc-387a-006e-62fd-177096ac480e@gmail.com>
Date:   Sat, 8 Aug 2020 09:59:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200808020617.GD2028541@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/20 8:06 PM, Andrew Lunn wrote:
> So i personally don't think netdev statistics is a good idea, i doubt
> it scales.

+1
