Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBCA4105A07
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 19:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfKUSzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 13:55:04 -0500
Received: from mail-lj1-f178.google.com ([209.85.208.178]:32909 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUSzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 13:55:04 -0500
Received: by mail-lj1-f178.google.com with SMTP id t5so4481890ljk.0
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 10:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=s0QE2H3Vz9dC7+kh9U1TNiHNA5HCZZ8y58YvdRMNQ0w=;
        b=iXWZz+pUxPzYExr3rOlakeWNdIY7t3PY9kYAeOZg8J+3xeg0qDJDe6NbXJtTSrg6HR
         RSVltooYlCv///5P4kDARA3j9lcogfmZtcWPrOmKRa+csencor1YXsdNISX7PDkHx8jA
         UeytBQsPkfPxuWFy1XBlAPyC13RFqcY8oNIKoWnuN4ydmZVO89mGWqIGSE0eY+4dB4RC
         hOPmNgIJhXI3/FuAStWJzemRJMbbQj8WJoUv7DMg9SewXRUIgp1D2vS3T6QwQbopCj2U
         Lwp+UrfpJXlzjd9TcHMT7qanbA3WGmtRCsKqomHZtvzsu11toirf0fMVbZ5LKXcbbnvz
         9yKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=s0QE2H3Vz9dC7+kh9U1TNiHNA5HCZZ8y58YvdRMNQ0w=;
        b=gqatEuKoPLxqnSWeQB320tg6iqI/Zc+9lfTSLVevN5PjcPFJSPgS3uPEejQ237om+l
         Fdc7UkAQbZdQwZ5kqTmjhC5L71RWDur1v/1UvebLMtcdtWFXFHDDgWmGIGzg6DSvGMh5
         BFGV3pQYYnsucLirlJ6vqLA/b9otnr2Iqza0JQk9owF123Bz6qOFEHViIQfmm3tnzYwp
         qStRuG3nNbHOrkzzQf8AaioM/84+xbwddfcd70OzawwCOBd073MCFNGp9eSaYniH6dps
         NEmmeZp2ODB/tp+dej8EcNm3Rc9dHkM8Z4burIec5MqN2LfXvgzxwqm2oBaXp1UyMLZu
         +81g==
X-Gm-Message-State: APjAAAXG3gwfAg3A3/OOm8uS1rw5KUB2n9I4k/QUg7EyUmL4iJvTHUSX
        UfNhjYdBkR2fURvzqPMHBJR+bQ==
X-Google-Smtp-Source: APXvYqxjJc0PWkm4YppKvBFhe/DYDA/Habs8+jVbl1eMARhBhqlMrW508Hxhabo5bXDxeIR5BYvIhw==
X-Received: by 2002:a2e:9ecf:: with SMTP id h15mr9070774ljk.173.1574362501949;
        Thu, 21 Nov 2019 10:55:01 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z127sm1895315lfa.19.2019.11.21.10.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 10:55:01 -0800 (PST)
Date:   Thu, 21 Nov 2019 10:54:42 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        simon.horman@netronome.com
Subject: Re: [PATCHv2 net-next 0/4] net: sched: support vxlan and erspan
 options
Message-ID: <20191121105442.1d79a17e@cakuba.netronome.com>
In-Reply-To: <cover.1574330535.git.lucien.xin@gmail.com>
References: <cover.1574330535.git.lucien.xin@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Nov 2019 18:03:25 +0800, Xin Long wrote:
> This patchset is to add vxlan and erspan options support in
> cls_flower and act_tunnel_key. The form is pretty much like
> geneve_opts in:
> 
>   https://patchwork.ozlabs.org/patch/935272/
>   https://patchwork.ozlabs.org/patch/954564/
> 
> but only one option is allowed for vxlan and erspan.

I have only cursory understanding of the flower parts, but looks good
to me:

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
