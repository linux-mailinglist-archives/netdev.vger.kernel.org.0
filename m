Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8044739D326
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 04:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhFGCvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 22:51:42 -0400
Received: from mail-ot1-f46.google.com ([209.85.210.46]:34734 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbhFGCvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 22:51:42 -0400
Received: by mail-ot1-f46.google.com with SMTP id v27-20020a056830091bb02903cd67d40070so12239749ott.1
        for <netdev@vger.kernel.org>; Sun, 06 Jun 2021 19:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h5FtfQ7i9sLu0wD1iQeQsh+PtvfP5lmdA7DIMM3/MBo=;
        b=bB9nrxz3rD7E0bJSpKMe28UX2nEsy+li/f3oYxfJKR6hl07g92+6nJz+x5AHOdfCY3
         MAtb6mHp40CW08caF1b4172nxG0w59KbrRlfgm/LGvrfLc2duzkH7+KMil1kncFTyUw/
         Yyaw2zODZAIlbqcTt60ULfC7JN4tfOSODNDVyvN/A3UPeOZFDuX0QHVHzKwpiyGtpqim
         ALFTFwyre6ZC5lWydymZBkYQRgcldIAR/BLvfNjtrxbzaYxE2ETX2w4HRv/CJARFao5k
         sSIUYcaEquhEM68GElJ4p6bulFRCB8ME5wqswAwf3mLSxsuankRket43ElFLpMkmoNHY
         r2aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h5FtfQ7i9sLu0wD1iQeQsh+PtvfP5lmdA7DIMM3/MBo=;
        b=ai9Mw1w9GUU4ZLRvhLmy2HYOj+YJz15LGkRXV0iiSbzQsGY4N+mHWzg63R/XUj1whs
         cpeaTtxr8DCkh/cHJ1BBBsREQPg7cthYWaZsOOcCANr+vyUYc/eFCzS5bt5nCOCBBEs7
         OersWz7Qf9BjjxV70qRf+RZeLfUFYi3mZZdkhzcmmW9wq0CRvDkzBxYxmtQRexJT2vIL
         ef7g4zLSLo1T8dsrzLMm09BRZKzchKdkiBgNo6E/Tx2OqUjNF6JMLQB9PbNiu0gLLuJw
         U8vElLCxjpYpMyPt6AXZxrXBRyO73rl1ANGTDXL77khwp5bsmCYscxi9dYSCWOt6L1Zy
         WNWw==
X-Gm-Message-State: AOAM532DYQMO7fzWgi1eJLP7PB2eq4rxf5ekGFzrj+AUEbQeVLwas2r5
        XAzSWoIGLeel1YZPuZSqzM0=
X-Google-Smtp-Source: ABdhPJw7F1oecm6IWeuVUqp0SHNkhNll+0ByV54mS7rWUH5djJgmjn+NmpAou7FsVpXDQO2JtG9Xfw==
X-Received: by 2002:a9d:a13:: with SMTP id 19mr12298474otg.131.1623034118395;
        Sun, 06 Jun 2021 19:48:38 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id p65sm1282537oop.0.2021.06.06.19.48.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Jun 2021 19:48:37 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3 1/1] police: Add support for json output
To:     Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org
Cc:     Paul Blakey <paulb@nvidia.com>, David Ahern <dsahern@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20210606062226.59053-1-roid@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4926d9e1-4b0a-75b8-6a63-c1fd67eff58a@gmail.com>
Date:   Sun, 6 Jun 2021 20:48:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210606062226.59053-1-roid@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/6/21 12:22 AM, Roi Dayan wrote:
> diff --git a/tc/m_police.c b/tc/m_police.c
> index 9ef0e40b861b..560a793245c8 100644
> --- a/tc/m_police.c
> +++ b/tc/m_police.c
> @@ -278,18 +278,19 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
>  	__u64 rate64, prate64;
>  	__u64 pps64, ppsburst64;
>  
> +	print_string(PRINT_ANY, "kind", "%s", "police");
>  	if (arg == NULL)
>  		return 0;
>  
>  	parse_rtattr_nested(tb, TCA_POLICE_MAX, arg);
>  
> -	if (tb[TCA_POLICE_TBF] == NULL) {
> -		fprintf(f, "[NULL police tbf]");
> -		return 0;
> +	if (tb[TCA_POLICE_TBF] == NULL || true) {

why '|| true'? leftover from special casing tests?



