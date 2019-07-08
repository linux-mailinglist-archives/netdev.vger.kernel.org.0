Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB70861D77
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 13:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbfGHLDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 07:03:31 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38510 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfGHLDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 07:03:31 -0400
Received: by mail-wr1-f65.google.com with SMTP id g17so6424001wrr.5
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 04:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t/ktZMzFQrqvJKwmpRsumXxECkWWkK6dC9+TTTnwy9w=;
        b=Ow8bd2sJjLBkVrDRECMvUe5/PFWOp8Y8i+Mr/XfHdbDzL3MbNqFNTMssHqY+Uke5UU
         Llo9PXpjP1rRQsOckJeERduxYZRm2+vEG2kwA9sbNRLSeZy7JebDyBPLV0/Myz/k+BQJ
         gOkaBJfot07MDf4VsPyq7B7cAQapQEhuD6jxYbON5t7C0fJTMYxLtpSqfx0d8DvYM25j
         v3gCOZO9tQms/rHKJMEm6/lG48ISJH+piMQTxbHOboBbVrseMqLWfFR/oZRy5Yat46YS
         xJWmrjXZcd9IP3WBGHa/1kIHY+96xE0SjVdWgL5g1g1/BlBPeF5Uytsgr9W/2fePt8Qz
         Hvsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=t/ktZMzFQrqvJKwmpRsumXxECkWWkK6dC9+TTTnwy9w=;
        b=tQJCym38wbKCKXoUulv1HQpw2jmLhDAvFU1uTYxlJoLnb5s9zE1KasLlZpvjFK2uHT
         kM3lcPCv7Ot1B4yD1aVAopl5j/uliMOriEga2Uh0x1OTqqujxTkGJq615qso8UQAezLD
         LC7pKTpiUAovT2mtuJZD99UhTplX9GNsfj+g9BYTAsgvC5hXQYwKkNidfUNtqH0dtgRg
         n7U6NMOaIvMvm0+A50MQz/g2wORV3Sj6xI+qzDzZABRyZPWoGiN2li5+xtlDRB28gzFc
         0PH9FdcuGm/ZaiiERkQOc8SQfCW+vbXwvFQpQmUkZo7mNVNBsS1yVB0KgcEK8hpXLoPG
         UpcQ==
X-Gm-Message-State: APjAAAWl4z3NyirSxFiQZ8/HoFhA5OY7FEeb+q/vtGT3XYPJdEj5UZZk
        +8nJ+TBEY2dlOeHqBtMfCc66OgT6dUI=
X-Google-Smtp-Source: APXvYqxwd1XrxI3OAX2pTx3vKdCeIqs9suKp5feyy3HvDR0+fuw5TxxdPQNVT78W83yr1PRxfzDT9Q==
X-Received: by 2002:a5d:4b8b:: with SMTP id b11mr4820706wrt.294.1562583809243;
        Mon, 08 Jul 2019 04:03:29 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id g11sm10283146wrq.92.2019.07.08.04.03.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 04:03:28 -0700 (PDT)
Date:   Mon, 8 Jul 2019 13:03:26 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@mellanox.com>, ayal@mellanox.com,
        jiri@mellanox.com, Saeed Mahameed <saeedm@mellanox.com>,
        moshe@mellanox.com
Subject: Re: [PATCH net-next 01/16] Revert "net/mlx5e: Fix
 mlx5e_tx_reporter_create return value"
Message-ID: <20190708110326.GA2201@nanopsycho>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
 <1562500388-16847-2-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562500388-16847-2-git-send-email-tariqt@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jul 07, 2019 at 01:52:53PM CEST, tariqt@mellanox.com wrote:
>From: Aya Levin <ayal@mellanox.com>
>
>This reverts commit 2e5b0534622fa87fd570d54af2d01ce304b88077.
>
>This commit was needed prior to commit f6b19b354d50 ("net: devlink:
>select NET_DEVLINK from drivers") Then, reporter's pointer could have
>been a NULL. But with NET_DEVLINK mandatory to MLX5_CORE in Kconfig,
>pointer can only hold an error in bad path.
>
>Signed-off-by: Aya Levin <ayal@mellanox.com>
>Signed-off-by: Tariq Toukan <tariqt@mellanox.com>

I'm not sure if the patch name "Revert: ..." is correct. I would rather
just describe the change and don't mention the "revert" even in the
patch description.

The patch looks good.
Acked-by: Jiri Pirko <jiri@mellanox.com>
