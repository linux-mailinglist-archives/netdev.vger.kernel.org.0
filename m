Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 209C155A4C
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 23:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfFYVxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 17:53:49 -0400
Received: from mail-oi1-f173.google.com ([209.85.167.173]:39342 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfFYVxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 17:53:49 -0400
Received: by mail-oi1-f173.google.com with SMTP id m202so327908oig.6;
        Tue, 25 Jun 2019 14:53:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=eoKGtDlKqpIxRnTHGXl8zjO5fMTGzW0LkDadKDQ6wTEUq4Io7tFTluvuVv0GYE3bnX
         /gju7rIkWs0OI80aqtQC77qkYPV/kbv30XXGjObht93YtqA3/5LZEjqcJu90DuWMyxQP
         0JqQcbNeW229kJ38hdX3WFd3gu5dvau+8Z/IoCbg4nxCNYDdkN+lSDac+3aJUN2st8cf
         Taibkby83XrSnSTZGy14FOi1ecLF7+uUogJvQxj9n/9x2j1f68XDuvNtu6yR1c1PloZR
         0Zm6rh5N9yoJytcNOj1RNawX6X+3uCK+8QtzW23Cxt9aly6URWXRi3nKRaxFKC1YOKLE
         XlkA==
X-Gm-Message-State: APjAAAWLe8ooTxc+aXthg3zedrdCQ7pU3Q+nwJEtC8C1EiA+KhDqh5+h
        A800oLs9FaK4xm/vO4Y2nFNG5DFV
X-Google-Smtp-Source: APXvYqxP8BS/GkDgwyOepZgrAq5wTRpM2J4mHVKpyw06liytge2rhWt5bNRkpJikA5QawRZQh2ttgg==
X-Received: by 2002:aca:ec0f:: with SMTP id k15mr15519842oih.13.1561499628121;
        Tue, 25 Jun 2019 14:53:48 -0700 (PDT)
Received: from ?IPv6:2600:1700:65a0:78e0:514:7862:1503:8e4d? ([2600:1700:65a0:78e0:514:7862:1503:8e4d])
        by smtp.gmail.com with ESMTPSA id s1sm5740376otq.28.2019.06.25.14.53.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 14:53:47 -0700 (PDT)
Subject: Re: [for-next V2 02/10] linux/dim: Remove "net" prefix from internal
 DIM members
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Tal Gilboa <talgi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
References: <20190625205701.17849-1-saeedm@mellanox.com>
 <20190625205701.17849-3-saeedm@mellanox.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <b517486f-a860-bf8d-fe72-edbb73d74254@grimberg.me>
Date:   Tue, 25 Jun 2019 14:53:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190625205701.17849-3-saeedm@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
