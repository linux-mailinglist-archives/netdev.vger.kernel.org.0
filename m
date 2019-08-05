Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD6A381FBA
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 17:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbfHEPEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 11:04:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728885AbfHEPEf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 11:04:35 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00229206C1;
        Mon,  5 Aug 2019 15:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565017474;
        bh=jk/fAuuZog76dawO1BTh9K0DlnzSAGQ/c9oCIJD/ZPM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=R3Lcx7HD1+L5K3lEv5JxQMQ0kwnWMlx/g+powkUUnYk+RNJfhjm+v4RENBwq9W0hU
         lIhpLOFRtxOM2EL/9rakrQieKoonxyZDyX9CzLtVtHXM7P3cwdr0CijHpNDP0qfRvu
         yyJTaB++ptpZIikwCieSVadNlhOptUS/A1tOtbfA=
Subject: Re: [PATCH]][next] selftests: nettest: fix spelling mistake:
 "potocol" -> "protocol"
To:     Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuah <shuah@kernel.org>
References: <20190805105211.27229-1-colin.king@canonical.com>
From:   shuah <shuah@kernel.org>
Message-ID: <75376116-74e5-83ea-2bf8-837b10ff5439@kernel.org>
Date:   Mon, 5 Aug 2019 09:04:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805105211.27229-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/5/19 4:52 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in an error messgae. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   tools/testing/selftests/net/nettest.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
> index 9278f8460d75..83515e5ea4dc 100644
> --- a/tools/testing/selftests/net/nettest.c
> +++ b/tools/testing/selftests/net/nettest.c
> @@ -1627,7 +1627,7 @@ int main(int argc, char *argv[])
>   				args.protocol = pe->p_proto;
>   			} else {
>   				if (str_to_uint(optarg, 0, 0xffff, &tmp) != 0) {
> -					fprintf(stderr, "Invalid potocol\n");
> +					fprintf(stderr, "Invalid protocol\n");
>   					return 1;
>   				}
>   				args.protocol = tmp;
> 

Assuming this will go through net tree

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
