Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70906D1FCB
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbfJJEuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 00:50:25 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44040 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfJJEuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:50:25 -0400
Received: by mail-pg1-f195.google.com with SMTP id u12so2829265pgb.11
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 21:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=gNeV6LKExuNf/MhSjo6ZU0gCKWYDAg+J3sOG4tIB+p8=;
        b=m7OuybvlQzdEj3USnsR65OQqEHQ6V/ER0jXUOp6c+qWzlYEHcII+CQ6Pt4thra1wTm
         GoSZwWTouCanm6PFhroudEJx8pjHxiEiglAIJMnXVpa5TIXwz/q9khB7qfQ8MQIGtj9b
         OoSRCVaMRYCaywp3KfUFdVbofPHIx+/QW/PJqvNaqgCOHn8qoz5XnAeEyv4UEPm7P9wY
         KAT6wtFZ9X1+B2gY6ETM+YVFgE+CSbdM9l1HvFyk9pIwp4FT3in5xfs1h3NbXEz8S7mL
         uMrAyKoluM3ABjPFLud5m6iMcw1ykZi1M0baSVTIrCdGjnWcHGKN3ssCKmwa+hNsDGe6
         M75Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=gNeV6LKExuNf/MhSjo6ZU0gCKWYDAg+J3sOG4tIB+p8=;
        b=pTnOvjls4cO3HILEdv1jXSGT+ZlUtqPEgxORJAwpKMSryZ0P1hwexh19ZBA8uotvLe
         uX/rXhdLLg3YaedN1QBX9NpKwDLXDV0IPRC0IZeulEgLkINJZT34S9BL2/dqOBCeZ5c6
         hsS8RqT9QLvWbJ7A5/xFW/KGYoa/XmGBpEz+zufeFFKZCuahEdkR+cip6OnJ3fLnMzmz
         LqXBy3uUitiarzFZ6alMbcombdoEajCIHZ0mKBJuXlTwTBagDyyOXf8L34uGURZc0GzZ
         dNFyJaAEuN/sjYxmDAdzSfi+cj9Xhx9MpEbvfd3uuBRYEgdNscDc/GxWzNyQPQJpzqkt
         9EwA==
X-Gm-Message-State: APjAAAUvrlfUJwGqSL4OMZHR3tppg5onLDwe7qPCFw1geWF+hv+S8G6k
        uPLp0pYZgj0ELmx31uBxMIr5Bhl80eE=
X-Google-Smtp-Source: APXvYqw8nkdTTrjmD5Vc82GbaB9LgYgbOgQrJdh/8UMN1wYTeofYGAUq25/aU5TXn8skIZjxOdt36g==
X-Received: by 2002:a63:d0a:: with SMTP id c10mr6498541pgl.203.1570683022914;
        Wed, 09 Oct 2019 21:50:22 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id m123sm5142490pfb.133.2019.10.09.21.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 21:50:22 -0700 (PDT)
Date:   Wed, 9 Oct 2019 21:50:10 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net] tcp: annotate lockless access to
 tcp_memory_pressure
Message-ID: <20191009215010.26167c5b@cakuba.netronome.com>
In-Reply-To: <20191009221015.36077-1-edumazet@google.com>
References: <20191009221015.36077-1-edumazet@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Oct 2019 15:10:15 -0700, Eric Dumazet wrote:
> tcp_memory_pressure is read without holding any lock,
> and its value could be changed on other cpus.
> 
> Use READ_ONCE() to annotate these lockless reads.
> 
> The write side is already using atomic ops.
> 
> Fixes: b8da51ebb1aa ("tcp: introduce tcp_under_memory_pressure()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks!
