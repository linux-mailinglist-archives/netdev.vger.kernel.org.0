Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA8848A579
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 20:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfHLSOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 14:14:54 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:36640 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbfHLSOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 14:14:53 -0400
Received: by mail-ot1-f68.google.com with SMTP id k18so30256380otr.3
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 11:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/Ig8V5oZNUYetyplWMD5Ehuw+FSL5uyd5457okFOL5M=;
        b=ovFFWUf7AQNbja1xZvJdrdwYJ2CdH2aXpvdjm8qdcPIm+sgNdNMxWP+mhDhhb7rrny
         VhzjvbGXjAsrpTeyhlzwBiJa7OMmsy4HDPrG4xNLqNH9M8XVX0/Qtyg7nuzeWHkiDCn/
         +F6tWaCez4WB/fecG/VSjJuN4gdzdZcU6zaDd5aEu5kblEz0btV9KZ/ahERcRKnyMaT6
         8FDdCd0brrCXqFYSldbaq6xzwwwRTXGIvuHxiupOWYRaHe8BMoMcgyy3dZyePtiszyQl
         7GhmZErCaZLfn2OWmGYky5Vet7OD3LQe1jRjSpefNwSbdj3iraM0UTTN/swGUuqoFMXp
         fXNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/Ig8V5oZNUYetyplWMD5Ehuw+FSL5uyd5457okFOL5M=;
        b=EpSCxiJVfFgrXQFrACWyHx+qdl3m2HtxSC7tLNmIw64NeYdU44KUAFx1nlTdntHwVR
         u2FNfzInn73UJMFcSADER7z3lB9veDgV/x+0301DtPKgbPwKj9eqKYbAExJ1WSG3jkvn
         aEdR043LJG2ZtBX1QvFzUheWoQYYdL2fLKK9nUocwBUVClm0rJZ1nEnTOdo+ljllXX27
         nz+4tYdWAItxAWbiAoxTvbBdxWUOFEElADF3Hya8fJ87tRBLXfhdIyk9jdHG9JA2IcdP
         Kxej8z6i9r1deZ1aAzQgfW73guxQBTMyPslwMNfCI/u6HgNsFdqL1murHwDLM9XyN+iE
         WhWA==
X-Gm-Message-State: APjAAAVExyCneJGNSZOjJBIg5q2pZK6CiuivFzpbgOLh1HKOZHFaeE90
        oevPVqLoXUA7fSFfbtGz+Si2zIQL
X-Google-Smtp-Source: APXvYqwOtQXx4h27QXqRuYhj8M1gztWJuXaQnJnZQzqLZpb7WbdoURKTTmhlydoDRsoVXJ993V+J5g==
X-Received: by 2002:a02:85c7:: with SMTP id d65mr39708993jai.8.1565633692567;
        Mon, 12 Aug 2019 11:14:52 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:1567:1802:ced3:a7f1? ([2601:282:800:fd80:1567:1802:ced3:a7f1])
        by smtp.googlemail.com with ESMTPSA id c13sm19083532iok.84.2019.08.12.11.14.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 11:14:51 -0700 (PDT)
Subject: Re: [PATCH 1/2] ip nexthop: Add space to display properly when
 showing a group
To:     Donald Sharp <sharpd@cumulusnetworks.com>, netdev@vger.kernel.org
References: <20190810001843.32068-2-sharpd@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b4180885-8181-a2ee-d333-73fc1d7a58db@gmail.com>
Date:   Mon, 12 Aug 2019 12:14:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190810001843.32068-2-sharpd@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/9/19 6:18 PM, Donald Sharp wrote:
> When displaying a nexthop group made up of other nexthops, the display
> line shows this when you have additional data at the end:
> 
> id 42 group 43/44/45/46/47/48/49/50/51/52/53/54/55/56/57/58/59/60/61/62/63/64/65/66/67/68/69/70/71/72/73/74proto zebra
> 
> Modify code so that it shows:
> 
> id 42 group 43/44/45/46/47/48/49/50/51/52/53/54/55/56/57/58/59/60/61/62/63/64/65/66/67/68/69/70/71/72/73/74 proto zebra
> 
> Signed-off-by: Donald Sharp <sharpd@cumulusnetworks.com>
> ---
>  ip/ipnexthop.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
> index 97f09e74..f35aab52 100644
> --- a/ip/ipnexthop.c
> +++ b/ip/ipnexthop.c
> @@ -186,6 +186,7 @@ static void print_nh_group(FILE *fp, const struct rtattr *grps_attr)
>  
>  		close_json_object();
>  	}
> +	print_string(PRINT_FP, NULL, "%s", " ");
>  	close_json_array(PRINT_JSON, NULL);
>  }
>  
> 

Looks right to me:
Reviewed-by: David Ahern <dsahern@gmail.com>

Stephen: this should go through your tree.
