Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 035AB12EA07
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 19:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbgABSmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 13:42:33 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36871 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727951AbgABSmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 13:42:33 -0500
Received: by mail-pl1-f196.google.com with SMTP id c23so18134700plz.4
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 10:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j636rVvRbbvUxOIE+x9pevDuspCP6Ufsybadz3bvMFc=;
        b=S/uOIv4gXiOkpSSR8jVT2++6+3pgA4AD34w0GsLNLizLOZlQU8FxvdJL55cqtQX+th
         96X//YMbOsTe2sxsfoRf5KWF5K5XWbQc/z0EAtVTDK33TBqLY/235gG3QePDNEXbT5j5
         FbDZ5PDz1Qx/rvt3ccPwF0+jMvGH/wl5LLjZYQnh0Sg1F6YVvUbTwpX97qzvdJJeV0He
         zUhq6ZDWL1yfIT4bSz0/ujIBL8rwkGZajybz4AlmINzoY6JuQo+c5LkWyH7DItxyPKZa
         stTAvpQUPO45NFO6EAFOYv4NR2cSuSH6oS2PdCFbGJuDDYBhsw+uiVMtj/98r3TDeGTr
         0VSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j636rVvRbbvUxOIE+x9pevDuspCP6Ufsybadz3bvMFc=;
        b=KEeNcRwFI+QQIrxQOPEcSkvD7Ax642gQDCI7hnOPr0krOnjNMfZaoinP1lQkOnLd6Y
         5A2FIH5WiUf4SXBwGOacAjdtwJitMlQgExoChNDWRugkht8IpCrDalOzkzPrxUkC0Jmf
         OkvZMx11gPofxX/1UGgRel7PcK7SEIPh3dMjD8g6O0DVkLg2iBvjnvVocfoS0bHQldqm
         8po0NMYd1HgD42HHfv2dbwaAmhQog8qYmPOyEUyZC7On5qh2YXRlvnuWZ3n02rHkQSg/
         8XyD1EzTX1Qh82wXFf+x703h5ws/GAZlEb4uoAqElvBbHY55oKrAwLhTKBIe8xxGShSF
         UHIQ==
X-Gm-Message-State: APjAAAUJCYm50HPScV8VBVUPat4ArzNvJ4Qv4VoL3vD3f2Z2oo+C0Fa3
        AXyxcZu3z2PZSZTPn6ny40ahYbuk
X-Google-Smtp-Source: APXvYqwVyJ56Btob/ovkE9nxsAtAuzjUqb/bEXSo21LuFfoH684kmcK5KSg2Zf3KxDbWTheq+hllqg==
X-Received: by 2002:a17:902:6501:: with SMTP id b1mr76292008plk.121.1577990552200;
        Thu, 02 Jan 2020 10:42:32 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:464:9ee1:192c:21fc? ([2601:282:800:7a:464:9ee1:192c:21fc])
        by smtp.googlemail.com with ESMTPSA id 133sm64409944pfy.14.2020.01.02.10.42.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jan 2020 10:42:31 -0800 (PST)
Subject: Re: [PATCH net-next] ss: use compact output for undetected screen
 width
To:     Peter Junos <petoju@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <20191226130709.GA29733@peto-laptopnovy>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f1e0e2e6-8f59-d0ee-9b70-c8c10ee42733@gmail.com>
Date:   Thu, 2 Jan 2020 11:42:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191226130709.GA29733@peto-laptopnovy>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/26/19 6:07 AM, Peter Junos wrote:
> This change fixes calculation of width in case user pipes the output.
> 
> SS output output works correctly when stdout is a terminal. When one
> pipes the output, it tries to use 80 or 160 columns. That adds a
> line-break if user has terminal width of 100 chars and output is of
> the similar width. No width is assumed here.
> 
> To reproduce the issue, call
> ss | less
> and see every other line empty if your screen is between 80 and 160
> columns wide.
> 
> This second version of the patch fixes screen_width being set to arbitrary
> value.
> 
> Signed-off-by: Peter Junos <petoju@gmail.com>
> ---
>  misc/ss.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 

...

> @@ -1159,9 +1159,15 @@ static int render_screen_width(void)
>   */
>  static void render_calc_width(void)
>  {
> -	int screen_width = render_screen_width();
> +	int screen_width, first, len = 0, linecols = 0;
> +	bool compact_output = false;
>  	struct column *c, *eol = columns - 1;
> -	int first, len = 0, linecols = 0;

moved the new bool after struct column to maintain reverse xmas tree and
applied to iproute2-next. Thanks,

