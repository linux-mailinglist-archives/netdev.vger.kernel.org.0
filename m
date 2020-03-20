Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6C9518DB45
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 23:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgCTWkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 18:40:09 -0400
Received: from mail-qk1-f171.google.com ([209.85.222.171]:42902 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgCTWkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 18:40:09 -0400
Received: by mail-qk1-f171.google.com with SMTP id e11so8793024qkg.9
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 15:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=guWvdGZuPcfC4G0GrTyxIW1rF9p7Hq5cbT0ydngDfXk=;
        b=P/KBRFMPA0EliOOspD7gVvVgAUoqJDSsazWSFqFjetJrhUARNU23rZO8RyIcAKwgS4
         IgAsq01Of+RowjZUu0BrUtqICWHn0MI8EimqdLeXjtEJE0YA1tH34+5ch+gFAXrQeKvZ
         MOtX0NbBIWdg5zOp3WKWyZP/Gq4Tc7ta85oVNVFX0VyAVKtiqRNhyEUlamwK3EQgPLvt
         lxET/v76k2WmY3TtsRdCPiNv+/8ZxU01EUPxUx+BVE+/2dZmt6wh96pGETe25AXgCzEK
         dCfZjBAQIGzbdulk9Jh6jPHB6QmR1QMokfWEY3vu9HSo+ruWihFECUPdkZ8CiS1QK+fi
         LoRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=guWvdGZuPcfC4G0GrTyxIW1rF9p7Hq5cbT0ydngDfXk=;
        b=OXo+wjPxuJemlP0i5fyu8FVUWgK8u2vhXoVoTrMcSU1v0wOZpHxEdP/oXkt43F2uVV
         QsUUFJWamgeb+q/S/+VptYH1yV2F43wXhE0Ywguf4iwr2LQFlgW4T2gLi28+XVM/g23n
         cUoYtNRvXhBBIrreA6Eq+Uoer4g1SK55JkDS4hS7yaDhdTOtC9iVHPwPe0fanQXpr7w5
         tY8w/oKIEn0k1KYcFCuCaD04QpPeqmxDARRcsCWthASJ77vEvc0AW3rKXaPPXdlH2qqK
         qDF/zhI+MvJShAyDdD0GEMp5vFxERzYwH+kujzQ0a0rsm9oG/DVdR/kDZRfcfOyiiXUZ
         FTCA==
X-Gm-Message-State: ANhLgQ2FwmFNlT9YA77Adb0yxD0ZZNs1J7LaW9CrQmJwP+8q0x6An9PJ
        b8Eite5/hF0Go3DvMxvjLRT799qv
X-Google-Smtp-Source: ADFU+vvKCMGA0snvHpCjpnIrOx4uIhGBeZFYrpGZURfcAioXEiudqbb+Pq1u4L/oF/AImMR3NrOGIw==
X-Received: by 2002:a05:620a:1231:: with SMTP id v17mr10317072qkj.126.1584744008199;
        Fri, 20 Mar 2020 15:40:08 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:d465:1fc5:8eed:dc67? ([2601:282:803:7700:d465:1fc5:8eed:dc67])
        by smtp.googlemail.com with ESMTPSA id r40sm6042544qtc.39.2020.03.20.15.40.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 15:40:07 -0700 (PDT)
Subject: Re: [PATCHv2 net-next 5/5] net: ipv6: add rpl sr tunnel
To:     Alexander Aring <alex.aring@gmail.com>, davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org
References: <20200320023901.31129-1-alex.aring@gmail.com>
 <20200320023901.31129-6-alex.aring@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6c8c0df7-340f-30fc-7ccd-40ae4fd597bc@gmail.com>
Date:   Fri, 20 Mar 2020 16:40:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200320023901.31129-6-alex.aring@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/20 8:39 PM, Alexander Aring wrote:
> +	err = nla_parse_nested_deprecated(tb, RPL_IPTUNNEL_MAX, nla,
> +					  rpl_iptunnel_policy, extack);

the name tells you not to use it for new code.
