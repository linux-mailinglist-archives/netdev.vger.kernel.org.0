Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D39931701
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 00:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfEaWNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 18:13:49 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32883 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfEaWNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 18:13:49 -0400
Received: by mail-pg1-f193.google.com with SMTP id h17so4787822pgv.0;
        Fri, 31 May 2019 15:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Zs72w1X3Xt8CWkfb5pSFrh+oDH9C1ioWuSVWrC/3HwY=;
        b=pL2HTowgWwenuuoPM1VuR6AAEucC/B+Dd++UCKlpjTsaSCEHFI2oBdXcWUYH7b5Efq
         /93gAlGtzb7FIIVEN++BlyCEhqYyk1g42qdcDBXFmNwHibcvNCEB1E0mqDGHrYmB/YA0
         9NNWfeaMIZFbml+qgG0xuuUKU+NrF6F0GRR82TUctgJedXhMXFgO3YRttTMjiY7cDTee
         hcNnh4n2qOsprf0tBZQ3CmRU7PgDd3xtohy3xceIQqxKDTrEJCj+3+l7RSlZB5mBzyzr
         aVXFHGqKM0IUPyd9J2dcU1orwveVbdZNdB1DeccPy1jTdGA4faWoaVHuA8QJwa7frvXm
         +SeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zs72w1X3Xt8CWkfb5pSFrh+oDH9C1ioWuSVWrC/3HwY=;
        b=nJg2apFeAZqtPOYe3JNcvIguHnWTdPrVWYRZYWGDvOFUWaph7vDN1hnIpLN1pZ97QA
         8olIjklrj0C3vW4p0lSy3QBkx4/m3hz7h7dtEI0v6R5/ISOUifn/U12b6tN5L8mBRu78
         RGz37qBNdV3u8hdsQ7Aj/2FmaYwYYk/6c4TVA1+c/B47cX+G3iO6qbDFsMBnmREQU+n8
         mEWOA4ibTZLFVEDFMtIa1BQxhXDC5xNfk55Ity1TkKrPGVK1OBmDZJ5t+f5ygx5ehK1p
         p0w43YHdJ+ZODR81S9MoM5q4IUs4J+gmpC+vF1NJgNPQZuzQznOnQ4FG6pdGxx22sv4A
         Vo+A==
X-Gm-Message-State: APjAAAXV2xl4VT17gJnntWfDLtsG5cBbPOr05ZDdorjzeAlCFgLsgQ0k
        2xDf6aVTPwV6+jHsccKl3I4=
X-Google-Smtp-Source: APXvYqzrgsSFlmcLvTNwdXofTE85WQN0G4KKalwEsvscA6exxcwv+UfT+frQwOwpKNvQIcHyyi+kDw==
X-Received: by 2002:a62:b50c:: with SMTP id y12mr7403890pfe.171.1559340828813;
        Fri, 31 May 2019 15:13:48 -0700 (PDT)
Received: from [172.27.227.252] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id k3sm6050016pju.27.2019.05.31.15.13.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 15:13:47 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v1 2/4] rdma: Add man pages for rdma system
 commands
To:     Parav Pandit <parav@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        stephen@networkplumber.org, leonro@mellanox.com
References: <20190531031117.60984-1-parav@mellanox.com>
 <20190531031117.60984-3-parav@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6f0ff987-62d8-a314-6d9e-636363729d6a@gmail.com>
Date:   Fri, 31 May 2019 16:13:46 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190531031117.60984-3-parav@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/30/19 9:11 PM, Parav Pandit wrote:
> +
> +.SH SEE ALSO
> +.BR rdma (8),
> +.BR rdma-link (8),
> +.BR rdma-resource (8),
> +.BR network_namespaces(7),
> +.BR namespaces(7),

Added the missing space before (7) and applied all of them to iproute2-next.
