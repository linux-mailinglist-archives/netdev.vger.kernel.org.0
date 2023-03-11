Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C8E6B5E37
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 17:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjCKQ6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 11:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjCKQ6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 11:58:40 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523C228233;
        Sat, 11 Mar 2023 08:58:39 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id o11-20020a05600c4fcb00b003eb33ea29a8so5340133wmq.1;
        Sat, 11 Mar 2023 08:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678553918;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gYhtny07TgU/2ARSSXxzlAUf+ZdBTw7Jk0REUrzBi5M=;
        b=g1Ky/AWpsS1E+b7CNk4RhT7HQwmjKG4eIkUG91eD/6ZvkJpk89jBiE78whHU9LZzAT
         SScGIBfAqGhiKuE/caiS1RqlvrMsKnI7mepFOxB74DXVYcUp9Xa64oIa1h8peIeTETUK
         NqsZaAtbKCfXuMdqYQjyrOWLgqeaXeyaBSqQPezwivUVGYIknkwA/UHEhUu+LgdT/rxm
         tOomq/k1/baTEZbbDFS5YsXhlTQ4nzrz89e2ZDpxLs6M8aK6GjPZa0ekdAs4lJIyICsg
         AzQibdncDpJWblecrYBRKwYlIAahCSdJd9SQJTKt4//Me3v3xkLg9q8ANzJdwBLRoCpM
         15UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678553918;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gYhtny07TgU/2ARSSXxzlAUf+ZdBTw7Jk0REUrzBi5M=;
        b=alC1LGK3+feYfsBPIX8I6RDeCdoZViZjmT68cTuRq1FfzCV9VV0EkRX7sfv403KyHY
         bI+9oxLieNnwVa4pbCJENL9mlfIBNHnfTh1POMtej4wUP3XqMoh8ed3LrcMVGzo/ig38
         rrSikKI/5C2Gunnq4AivIgORo4K6kGzFhy6ZR5LaRd8hFITXEYlDZpJ1qKqlPdjtZWS7
         lOLDUBtSeiqzTCrCajDq6m9f5UGyT3MxQlAknV/dVcX6Td1vEid0m0WTVs2ghwjaJw2U
         ZEW/kyIh+yG+qVkuJKDzweqhnyXC0a3uGDQPuXtNi7/JxvhHUM1RJ5b1XtVS5xAY7QrO
         1OMQ==
X-Gm-Message-State: AO0yUKWMiMrsk1ANkw8XicSC2yw21SL42uoD1xTxUUcDn+K6M8HzfHm2
        FJpGu4fa6b3ZbettmQWcoydr4wRloifVwmV1
X-Google-Smtp-Source: AK7set+b/i/qqjMwDoYcKIR6gfrtfJ19XtiYu2ZwWCRUYh/AL6/DrVFeYPMKKYXR5zOd3doURYBATw==
X-Received: by 2002:a05:600c:190b:b0:3e8:490b:e28b with SMTP id j11-20020a05600c190b00b003e8490be28bmr6254311wmq.25.1678553917694;
        Sat, 11 Mar 2023 08:58:37 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id f22-20020a1cc916000000b003df5be8987esm3259673wmb.20.2023.03.11.08.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 08:58:37 -0800 (PST)
Date:   Sat, 11 Mar 2023 19:58:32 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Sumitra Sharma <sumitraartsy@gmail.com>
Cc:     outreachy@lists.linux.dev, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, coiby.xu@gmail.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: qlge: Fix indentation in conditional statement
Message-ID: <cf0bf6c1-30fb-4c63-9c17-575c87c986e3@kili.mountain>
References: <20230311152453.GA23588@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230311152453.GA23588@ubuntu>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 07:24:53AM -0800, Sumitra Sharma wrote:
> Add tabs/spaces in conditional statements in qlge_dbg.c to fix the
> indentation.
> 
> Signed-off-by: Sumitra Sharma <sumitraartsy@gmail.com>
> ---
>  drivers/staging/qlge/qlge_dbg.c | 35 +++++++++++++++------------------
>  1 file changed, 16 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
> index b190a2993033..c7e865f515cf 100644
> --- a/drivers/staging/qlge/qlge_dbg.c
> +++ b/drivers/staging/qlge/qlge_dbg.c
> @@ -351,26 +351,23 @@ static int qlge_get_xgmac_regs(struct qlge_adapter *qdev, u32 *buf,
>  		/* We're reading 400 xgmac registers, but we filter out
>  		 * several locations that are non-responsive to reads.
>  		 */
> -		if (i == 0x00000114 ||
> -		    i == 0x00000118 ||
> -			i == 0x0000013c ||
> -			i == 0x00000140 ||

You've written this on top of the other patch which we're not going
to apply so it's not going to work.

> -			(i > 0x00000150 && i < 0x000001fc) ||
> -			(i > 0x00000278 && i < 0x000002a0) ||
> -			(i > 0x000002c0 && i < 0x000002cf) ||
> -			(i > 0x000002dc && i < 0x000002f0) ||
> -			(i > 0x000003c8 && i < 0x00000400) ||
> -			(i > 0x00000400 && i < 0x00000410) ||
> -			(i > 0x00000410 && i < 0x00000420) ||
> -			(i > 0x00000420 && i < 0x00000430) ||
> -			(i > 0x00000430 && i < 0x00000440) ||
> -			(i > 0x00000440 && i < 0x00000450) ||
> -			(i > 0x00000450 && i < 0x00000500) ||
> -			(i > 0x0000054c && i < 0x00000568) ||
> -			(i > 0x000005c8 && i < 0x00000600)) {
> +		if ((i == 0x00000114) || (i == 0x00000118) ||
> +		    (i == 0x0000013c) || (i == 0x00000140) ||

If we could have applied the patch then I wouldn't comment here.  But
since you're going to have to redo it anyway...  I would probably have
kept these on separate lines.

		if ((i == 0x00000114) ||
		    (i == 0x00000118) ||
		    (i == 0x0000013c) ||
	            (i == 0x00000140) ||
		    (i > 0x00000150 && i < 0x000001fc) ||
		    (i > 0x00000278 && i < 0x000002a0) ||

I like that you are looking around and making changes, like this but to
me it seems more readable if 0x114 0x118 etc are all in the same
column.

> +		    (i > 0x00000150 && i < 0x000001fc) ||
> +		    (i > 0x00000278 && i < 0x000002a0) ||
> +		    (i > 0x000002c0 && i < 0x000002cf) ||
> +		    (i > 0x000002dc && i < 0x000002f0) ||
> +		    (i > 0x000003c8 && i < 0x00000400) ||
> +		    (i > 0x00000400 && i < 0x00000410) ||
> +		    (i > 0x00000410 && i < 0x00000420) ||
> +		    (i > 0x00000420 && i < 0x00000430) ||
> +		    (i > 0x00000430 && i < 0x00000440) ||
> +		    (i > 0x00000440 && i < 0x00000450) ||
> +		    (i > 0x00000450 && i < 0x00000500) ||
> +		    (i > 0x0000054c && i < 0x00000568) ||
> +		    (i > 0x000005c8 && i < 0x00000600)) {
>  			if (other_function)
> -				status =
> -				qlge_read_other_func_xgmac_reg(qdev, i, buf);
> +				status = qlge_read_other_func_xgmac_reg(qdev, i, buf);

This change wasn't described in the commit message.  This change is a
borderline situation on the one thing per patch rule.  We would
probably allow it under certain circumstances if it were described
correctly in the commit message.  But with Outreachy we're crazy strict
about stuff like this.  Just send it as a separate patch.

So now this is a v2 patch situation.  Outreachy has their own docs.  But
I have a blog about this which is super short.
https://staticthinking.wordpress.com/2022/07/27/how-to-send-a-v2-patch/


regards,
dan carpenter

