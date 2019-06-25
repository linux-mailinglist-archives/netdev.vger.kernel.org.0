Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0AA55A6B
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 23:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfFYV5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 17:57:07 -0400
Received: from mail-ot1-f48.google.com ([209.85.210.48]:44585 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbfFYV5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 17:57:07 -0400
Received: by mail-ot1-f48.google.com with SMTP id b7so394199otl.11;
        Tue, 25 Jun 2019 14:57:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=puOm259ixiQDdls1w7MqTlnKOk5wvQo7wY+pq9CpLSQ=;
        b=VRvcLc+E2yBJfgSo7Fw5jhOI2hIKj9T/xEnhpvaw9CcrM0UdN+ECEWs+QPYiz0sTRf
         ogadBIKqt1oRtlk5520SxwyiTTRiqJoZQmu6qUSuuH3blLA3rJKWAfJxTHbRpwFQhmd/
         wv0TiVAX2OLIOD45jU/KpT7yITte0r+HD8uacuVI1rvFRuU15Pdm0jp3FzPLSnjuofDr
         J6PsxZcb3FgkhfhAC6nyQSz/Upi4BF7Y7pf/zaHYIXpE0aCSUd2OT5VykdaqSk+TRokT
         tSgy9X5Vio60PUUue7jUEZXin3f5S6w9x7rzDxy3/qZMkAveIQSMceutCjYxH/qwaXa+
         OomQ==
X-Gm-Message-State: APjAAAX6CeVVA+9KkOr0klF7x7T64gUU8XRetXqLwNxiDqgb7UM1wnfi
        3epT9VXMgt6gOVnDDo4dOgbPflMw
X-Google-Smtp-Source: APXvYqy8p/bfBJYEwq5cBqmpmgrTU9VyqcxDvS67c9vLzAQmhpjvBZIqPjcPep71uYh6Wo7UJrwTeQ==
X-Received: by 2002:a9d:66cd:: with SMTP id t13mr493496otm.83.1561499826445;
        Tue, 25 Jun 2019 14:57:06 -0700 (PDT)
Received: from ?IPv6:2600:1700:65a0:78e0:514:7862:1503:8e4d? ([2600:1700:65a0:78e0:514:7862:1503:8e4d])
        by smtp.gmail.com with ESMTPSA id 68sm6114711otg.78.2019.06.25.14.57.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 14:57:05 -0700 (PDT)
Subject: Re: [for-next V2 05/10] linux/dim: Rename externally used net_dim
 members
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
 <20190625205701.17849-6-saeedm@mellanox.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <c97bbab4-13a9-b9e1-69f2-d4aba43e1c06@grimberg.me>
Date:   Tue, 25 Jun 2019 14:57:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190625205701.17849-6-saeedm@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Question, do any other nics use or plan to use this?

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
