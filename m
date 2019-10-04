Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C016DCBF9D
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 17:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390045AbfJDPp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 11:45:26 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50620 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389669AbfJDPp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 11:45:26 -0400
Received: by mail-wm1-f66.google.com with SMTP id 5so6357400wmg.0
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 08:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GMF+7XBnTmTFkSIQGTJb4kA1y9i7Bjx3+PHddrH5eqs=;
        b=Ci9vsjtPkNe4Wwhuruc+SpFqg6hA9WQn6OPYgCHkxHe0ZFPqGNEpU3p6F7EBiM71jv
         +idh+JoAV/fDbPT0rN9+d3zIJG6fFwXq1dAfP9neb918YD875mPKza/Tf3TpIpbuFXnC
         85h6dt1d8K6Ta7WAiszH54LqG96AalJLHaruxr9jFu2ZlA2CWWYAToPEv5qTFdBG0dMO
         i4teoArYuV40caoxEBGY+EmrtGf0gpI8yVLs21HPgwkJusIHghmF6CB0CySI1WKz+EJJ
         b1UEEmly5IY+uxbfWKmCSdQQ0rrC1wVG35TlPx489Z7qAeG2fiivneTWBrdjPe7xhAlU
         bjwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=GMF+7XBnTmTFkSIQGTJb4kA1y9i7Bjx3+PHddrH5eqs=;
        b=e3AyLUbR04jI6dF0oYEikkQ7khiAk6bi1nrv3MokAu/2xjrho5asrUZ1FII3OpwuHS
         Z0rfm6cLh2cvR1XvT9VDztfO18BXDYOirXdzy4GLJWQ+SUkn/DulnFV4cipqza7u2PKv
         pLtuQD9dHyrd2l8Ehu1ob5A1p4ByuZgtOSuoCbqho+e5vX4jPFnro6cFMgWnKBfmWwNU
         92ZGQmrR0ZLp3lkGt4cEKPxaPDQRoqBsMBvhIyf1o1Kfj8tx8I/w82H/IvvVasQX+kh9
         hjWblgUA5KcD8p4GR41X3R1kC9G2TIUVvdei79/DhUVZU7wZWgj698lG2nkMqoH17Vkp
         zDYA==
X-Gm-Message-State: APjAAAV+cd3eMZ7EqwEeTxCNPk0TIluZadAB2l0xm8z5jpjZTjnAkSyO
        G2+453LHjZ7OkPsemHN/51VALtvBI+k=
X-Google-Smtp-Source: APXvYqwNYoINJ/6tvjnSXwXGnblYE+c5NVWqup31odcZ/ubAlSo73UJOoqA0TSKqupm8uuDECbbx9g==
X-Received: by 2002:a7b:c247:: with SMTP id b7mr11394188wmj.121.1570203923773;
        Fri, 04 Oct 2019 08:45:23 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:f54c:7c85:2761:59fb? ([2a01:e35:8b63:dc30:f54c:7c85:2761:59fb])
        by smtp.gmail.com with ESMTPSA id v6sm7009487wrn.50.2019.10.04.08.45.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 08:45:22 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next 0/2] Ease nsid allocation
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
References: <20190930160214.4512-1-nicolas.dichtel@6wind.com>
 <20191001.212027.1363612671973318110.davem@davemloft.net>
 <30d50c1d-d4c8-f339-816b-eb28ec4c0154@6wind.com>
 <20191003161940.GA31862@linux.home>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <8eec279e-c617-b2a5-e802-4b6561cd2f94@6wind.com>
Date:   Fri, 4 Oct 2019 17:45:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003161940.GA31862@linux.home>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 03/10/2019 à 18:19, Guillaume Nault a écrit :
[snip]
> Why not using the existing NLM_F_ECHO mechanism?
> 
> IIUC, if rtnl_net_notifyid() did pass the proper nlmsghdr and portid to
> rtnl_notify(), the later would automatically notify the caller with
> updated information if the original request had the NLM_F_ECHO flag.
> 
Good point. Note that with library like libnl, the auto sequence number check
will fail (seq number is 0 instead of the previous + 1) and thus must be bypassed.
