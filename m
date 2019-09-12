Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E891EB117B
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 16:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732843AbfILOwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 10:52:07 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33187 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732828AbfILOwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 10:52:07 -0400
Received: by mail-qk1-f196.google.com with SMTP id x134so24761313qkb.0;
        Thu, 12 Sep 2019 07:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=z4HQp7N624oJ0yhlnqhzRGFHkFho3LSPD+l62lmMuTU=;
        b=TKQgwHFvbeqR4PGRQJw7bYJ5lsVB1XDCd5XTAD///awMpCWVdslTN4QmcCPYLR+/3J
         eYVeVThtkRkuJE/eRH7kmeH1wpnWbqb0yxfXePZo+ZutBOCS/VVVtbjP97W+02XysG5Q
         gINMLfhzEaLKILtA2Ch8RnEajYC+1XM8Lj6f6pKKR2OZuu04C5cFZmg1YN210BI6QHf6
         GwisLYxQ/GsUGuoP9nIsjU+D3XkOy7Oamlrf0fiLC31mIGhX56kZmj8J1MAEeDGTCAWu
         W0GaiuL+bv9gLg/5DwLfXLJ76Md8hnq9fXmVoN3R/foXhAgKK7C2guV4A7kSrefDIeSv
         UO1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=z4HQp7N624oJ0yhlnqhzRGFHkFho3LSPD+l62lmMuTU=;
        b=O62onF1B+d8dS9f1KYzy0lMXWxFLLIzJpfEe4Ggdazz7RNncZsuMAXonp+h+VR18Y0
         pRGKlEkCKpfzloQWs31FYfgAbfi1BeyShUJ6+ZCTWy/tfNP1U2QHKk7ws7d7DU9qfGV/
         jV1HjjqejSbm16+Z7P3F466qjjh/XTS4BX/QgbdOh6DUPslTPXanypSF+q1YuEPQ0nyt
         3Br/XI1t3hJzLZuwuH5R/MCbNKMvO/eVhuAau3Rx8Nc6zPaDfOT2DhWzXtGxwRZeHUD8
         XZlRmaxz4zDz+N7EtYahMwjQb1XupVb+geodQ9fGzF/GFM4A0aYIWzupcueIZyNGrbhQ
         bHdw==
X-Gm-Message-State: APjAAAWUlY25ohXPn8VcrQnnPClLv3NQM/HtDtF+FvaJ084KWO5TBMAw
        nPV6m5FyksuQ/zCNYVEU8DA=
X-Google-Smtp-Source: APXvYqzAybPb42+If5M7wdu02AJv8jhm3orWyoi/nf38zkcPlKLB2bk/UHjLqATlDTtN1j+ixKaJ9w==
X-Received: by 2002:a05:620a:15fc:: with SMTP id p28mr10347606qkm.487.1568299926291;
        Thu, 12 Sep 2019 07:52:06 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:e600:cd79:21fe:b069:7c04])
        by smtp.gmail.com with ESMTPSA id a4sm11662247qkf.91.2019.09.12.07.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 07:52:05 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 322E6C0DAD; Thu, 12 Sep 2019 11:52:03 -0300 (-03)
Date:   Thu, 12 Sep 2019 11:52:03 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 net 2/3] sctp: remove redundant assignment when call
 sctp_get_port_local
Message-ID: <20190912145203.GS3431@localhost.localdomain>
References: <7a450679-40ca-8a84-4cba-7a16f22ea3c0@huawei.com>
 <20190912040219.67517-1-maowenan@huawei.com>
 <20190912040219.67517-3-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912040219.67517-3-maowenan@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 12, 2019 at 12:02:18PM +0800, Mao Wenan wrote:
> There are more parentheses in if clause when call sctp_get_port_local
> in sctp_do_bind, and redundant assignment to 'ret'. This patch is to
> do cleanup.
> 
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
