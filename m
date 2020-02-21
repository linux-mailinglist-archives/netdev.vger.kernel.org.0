Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D7D166DC4
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 04:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbgBUDdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 22:33:38 -0500
Received: from mail-pj1-f52.google.com ([209.85.216.52]:50347 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727944AbgBUDdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 22:33:38 -0500
Received: by mail-pj1-f52.google.com with SMTP id r67so126976pjb.0;
        Thu, 20 Feb 2020 19:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=uVDXWSOoE3NIUlB15U8IMoPrpK+RxsWu+4UikNAI7L8=;
        b=CTM8VZbwOWtkxzdnuhCVPjPWLAzjC49zcyIKrPnqEKXJAHYO51CicZs+PtCSbPIhqG
         ypuBYuqiUxdkPQUScW5/2MKtEB0XztvXVa3ec81COZSEpw+hMNa6yquknxLRNEPQ2Who
         vejuR+ZO2lmujRtMgbPk3DNMh7+gdvsYMNUB+ju7jmt8fsDxjbzRnYHgifOhvMyDjqr9
         P4GtwniIrf4cR7lqvH5DTqRzbbiNtPB4HEP0kjEzGy+dMxAzG74DWyy0g3KQDkFaj4vS
         QflPfKpXofQHHNepqDgmdF6UsqL55NuYbWtZlJApgkvcj5NYZNt5QEvNb4dF+oLwN1m+
         PzYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=uVDXWSOoE3NIUlB15U8IMoPrpK+RxsWu+4UikNAI7L8=;
        b=Di6HkKjiwsBDZODcxQBIleSqbyb7V2hKck6CkP8BkNKn7DPVA/XNVYu/o08ddGa8yE
         ZE6hW5adl7bToj9pTo2flOkAjEQBnoRT6yeA8YFRRY13xVX8n87aQJ474NLaFGnYlEyS
         zqlYHT3cHnE/Vhe691csvdba3QNGP63s3K82fYnQ4tNlUbWgZ4fyDySKzjXSV9lnVL3T
         ECNz1BzinE/h5WmgrnNqWTn7tANcVviwwZ3/gltFrYl1n9/KRKmjmGxBwCc5nfQmAy37
         G81+sZB0TZeFpsKW0HmIpUBQxa5j/6UJTNyaEp5BxirsQo2OelEcWtiNf4f8FH4AWxc/
         IgGg==
X-Gm-Message-State: APjAAAWUVJC3hCOnPNzAbz+dWP86PvVRRq+jwB90tsB/5k4HkuoJx9px
        HPe2smnwud8AojuS62+d9/M=
X-Google-Smtp-Source: APXvYqzkBphWmsVxodaI54/Gjsyh9+sYWNtDOzTxSh8qqCH74zzhPc3d+rheToNZL0MG47DAIqK7wA==
X-Received: by 2002:a17:90a:30a4:: with SMTP id h33mr549545pjb.50.1582256017887;
        Thu, 20 Feb 2020 19:33:37 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id e1sm981936pfl.98.2020.02.20.19.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 19:33:37 -0800 (PST)
Date:   Thu, 20 Feb 2020 19:33:30 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Message-ID: <5e4f4f8a876c8_18d22b0a1febc5b87e@john-XPS-13-9370.notmuch>
In-Reply-To: <20200218171023.844439-5-jakub@cloudflare.com>
References: <20200218171023.844439-1-jakub@cloudflare.com>
 <20200218171023.844439-5-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next v7 04/11] bpf, sockmap: Allow inserting listening
 TCP sockets into sockmap
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> In order for sockmap/sockhash types to become generic collections for
> storing TCP sockets we need to loosen the checks during map update, while
> tightening the checks in redirect helpers.
> 
> Currently sock{map,hash} require the TCP socket to be in established state,
> which prevents inserting listening sockets.
> 
> Change the update pre-checks so the socket can also be in listening state.
> 
> Since it doesn't make sense to redirect with sock{map,hash} to listening
> sockets, add appropriate socket state checks to BPF redirect helpers too.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
