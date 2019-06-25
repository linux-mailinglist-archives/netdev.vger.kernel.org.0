Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A60E55A51
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 23:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfFYVy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 17:54:29 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:45104 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfFYVy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 17:54:29 -0400
Received: by mail-oi1-f194.google.com with SMTP id m206so299427oib.12;
        Tue, 25 Jun 2019 14:54:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6KasgTK5/+VuZL+PHIPQJwMjs+IvVkXo0ARvzNGiIQg=;
        b=PbBoe9aknR2hJcRebpHr5eZTJ/4pzIOG21gKIsuTFmogYRCGm3mAiGNzZjlLDqLrIm
         EIDqeL6nxHPP5bH9p18qjDxi6CjRm30Ye+sB91ZSMRYx37dFW3loth1eG7FrT/TZN6Hd
         WWrO16yinEVGF1UaAucywRnb5Zr0aivOtHIhplOeLaVoDI4cToCZUa2w1dBZBbQE3smv
         qWtdrHSf5J5KatlAKej0cSVG71Zk+vh2ea+gt9aX2kLEPTXh7YjD9FaxtIL1ac211+CS
         9pPHIHpcOsoz61PdtoSzuSDyWJOktGhlH301CTEuT4SXu+XCRDpdaAtcT9GDK6QsKzvb
         HPsw==
X-Gm-Message-State: APjAAAXu8nGycW2H3Qdnlnk7na3nUxc4CCagmH2D1okhWKB2smLma2T4
        iDpm700kMBE4VZVfyutPhkLURH2H
X-Google-Smtp-Source: APXvYqxyMRSmVugV5yYEEDBuWCTrKjdUkuehnfzUnuNQYosa75JfqCSutIdx0Cv5uPvp0yH6IE/OBA==
X-Received: by 2002:a54:4f97:: with SMTP id g23mr15980949oiy.97.1561499668250;
        Tue, 25 Jun 2019 14:54:28 -0700 (PDT)
Received: from ?IPv6:2600:1700:65a0:78e0:514:7862:1503:8e4d? ([2600:1700:65a0:78e0:514:7862:1503:8e4d])
        by smtp.gmail.com with ESMTPSA id l15sm5936220otr.38.2019.06.25.14.54.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 14:54:27 -0700 (PDT)
Subject: Re: [for-next V2 03/10] linux/dim: Rename externally exposed macros
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
 <20190625205701.17849-4-saeedm@mellanox.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <3c38dc56-24de-0d47-d11c-4cb7a55b009c@grimberg.me>
Date:   Tue, 25 Jun 2019 14:54:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190625205701.17849-4-saeedm@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This can be squashed to the prev one, otherwise

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
