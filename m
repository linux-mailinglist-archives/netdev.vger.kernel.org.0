Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCDD447873
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 03:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236247AbhKHCSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 21:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbhKHCSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 21:18:38 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D61FC061570;
        Sun,  7 Nov 2021 18:15:55 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id b4so13788241pgh.10;
        Sun, 07 Nov 2021 18:15:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8ajGzyaiyWSyBzH0DDJA7FPiHlnWQp8BrhCgl6CKPaQ=;
        b=ZNwh/snx6SoZGpPp8E42i1Ky3yrz0OU2AHmU0h7bWBPkAyWKumEtX5PsRt7mCU8AaX
         gOc+TnF3wKtc3k90Z4D2wS05p1C4yDlu7+trukcyPWAuTkjcI8MN/7d2Naf9SxCJhwxc
         GPZChIXNeO0dd59H/qh4CAZ8k/7X3oTfLIaZoa78xR+Ki+EJLmWo9JwQYDcslcmthEd1
         eFfJ2kcdXeM2n9b7FECIrXsflRRAt8O/XflfUoUPyNIkxGU7dK2WB01G7gcajgI1Pcq6
         bBv/3rYxLvGfJTr064UO/L7Wt6zz/5WFU4Zh4IQTyrco0k8Jt+ZlcxLQz41y/Bsus7/3
         r6+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8ajGzyaiyWSyBzH0DDJA7FPiHlnWQp8BrhCgl6CKPaQ=;
        b=F0SwlPTICTIrav3wgHD6lMqfWpKxwi4njRAhF0h8RMI9TPzl7XXpYsIbJIcHFrR6Vy
         vEkzk7Hz+eQsmFvTQ3Fd6yG1iP4gCoItl6GAVNCh4sggqPK7HJo3mq4cKG3mpCmU8rQA
         J4tMXBxhSQagHQOCygU2L8bbQUMpxXae9Pq0kaDkD9EYhvFrhCV53nZI4c1cVGmzFf26
         hDsET25iFb1t3yH7LNtMLRaxT+rEnNAjBCjpaF36O30X4P683n+A93fhVVCagcLFqxrZ
         y+s0R344z4od4SJfD9glM9/qGX0/8hczYHb21uKxsI1+TJVRf6f79UPh7MCPHOqz7Z4l
         UxeA==
X-Gm-Message-State: AOAM531Txo+BjxLfQtmJv/z29iaaKNJaOUzmJtRKz6xNdM0VAVsGjuaX
        LOUBeop1btbbHcnmcSB84+YPXJZlujU=
X-Google-Smtp-Source: ABdhPJxyv9dFy6L74XQaBL1l4jM7d6N6h6Y7flW4iTVFV716Ek4sw4nR2m15RsEbYmsHaMprHSp3jA==
X-Received: by 2002:a63:2bd5:: with SMTP id r204mr57649415pgr.407.1636337754971;
        Sun, 07 Nov 2021 18:15:54 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l12sm14249470pfu.100.2021.11.07.18.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 18:15:54 -0800 (PST)
Date:   Mon, 8 Nov 2021 10:15:50 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf 0/4] Fix some issues for selftest
 test_xdp_redirect_multi.sh
Message-ID: <YYiIVu/c/f8ChbgD@Laptop-X1>
References: <20211027033553.962413-1-liuhangbin@gmail.com>
 <a3257169-b252-9446-1893-08ef9d1f9bcf@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3257169-b252-9446-1893-08ef9d1f9bcf@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 05, 2021 at 04:46:45PM +0100, Daniel Borkmann wrote:
> Applied, thanks, been fixing up a small merge conflict in the last one due to
> 8fffa0e3451ab ("selftests/bpf: Normalize XDP section names in selftests"), pls
> double check.

Thanks. I just checked and the merge is correct.

Cheers
Hangbin
