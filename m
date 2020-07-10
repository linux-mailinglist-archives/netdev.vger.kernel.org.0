Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77CF21AD08
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 04:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgGJC0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 22:26:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54234 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726509AbgGJC0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 22:26:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594347967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F/QXeAQOsoQD8NL9irQgu1sbGulZ7WIu0KVYQaTLeFo=;
        b=ith0DwD4cKUYHbm1mtTs0Xn+zdS2QIuSfO9SgoFaLbNE5wPUMyJ9DFu2JxesY43wsggUQ8
        DDTZjZufgjXP4hi81p35OW3WXyTPGWQ7RW+MkIp9jC7q3m057ld0dds44S4jnFwL7hm2M6
        Pf4nrNfvJwjDCQHoUA3e97CQdOdvphA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-dxFdVKTsNnGwt0-XhgWKbw-1; Thu, 09 Jul 2020 22:26:01 -0400
X-MC-Unique: dxFdVKTsNnGwt0-XhgWKbw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 856091902EA1;
        Fri, 10 Jul 2020 02:26:00 +0000 (UTC)
Received: from [10.10.120.78] (ovpn-120-78.rdu2.redhat.com [10.10.120.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D9DBA27DE7C;
        Fri, 10 Jul 2020 02:25:56 +0000 (UTC)
Subject: Re: [iproute2-next] tipc: fixed a compile warning in tipc/link.c
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>, maloy@donjonn.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
References: <20200709042555.5424-1-hoang.h.le@dektech.com.au>
From:   Jon Maloy <jmaloy@redhat.com>
Message-ID: <dd1c18c8-c71a-0510-0ef3-ad6c14f3c42e@redhat.com>
Date:   Thu, 9 Jul 2020 22:25:56 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200709042555.5424-1-hoang.h.le@dektech.com.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/9/20 12:25 AM, Hoang Huu Le wrote:
> Fixes: 5027f233e35b ("tipc: add link broadcast get")
> Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>
> ---
>   tipc/link.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tipc/link.c b/tipc/link.c
> index ba77a20152ea..192736eaa154 100644
> --- a/tipc/link.c
> +++ b/tipc/link.c
> @@ -217,7 +217,7 @@ static int cmd_link_get_bcast_cb(const struct nlmsghdr *nlh, void *data)
>   		print_string(PRINT_ANY, "method", "%s", "AUTOSELECT");
>   		close_json_object();
>   		open_json_object(NULL);
> -		print_uint(PRINT_ANY, "ratio", " ratio:%u%\n",
> +		print_uint(PRINT_ANY, "ratio", " ratio:%u\n",
>   			   mnl_attr_get_u32(props[prop_ratio]));
>   		break;
>   	default:
Acked-by: Jon Maloy <jmaloy@redhat.com>

