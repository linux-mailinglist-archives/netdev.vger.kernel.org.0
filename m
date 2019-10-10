Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B58D1D40
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 02:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732487AbfJJANh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 20:13:37 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46844 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732140AbfJJANh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 20:13:37 -0400
Received: by mail-qk1-f193.google.com with SMTP id 201so3921766qkd.13
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 17:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=aAs8iRiZBNjQQ2FpDAsqfhnKTgizd2FKSQYKAcq4guM=;
        b=AsBRBd92lyyExMDvyruXIGEzWuwqCNR/RMg7kANI7VLFhA7wQU9yZ8a0d383VecUU9
         lDy5jEvXjTuXSOXkpKYFsyLlV+j7ZBn5KsiK9ZmsRw+CPG9sKu5LXmA3qyOu9An1M8s4
         bL+TUr+VPT5EU2hsOVuLINRrv9jdIYPqVsHivxMyMj3hJ8r7q/ikr+8/ab8x9FWCtyRE
         TbUm6alXZU+It2YsCZWPj0pCGjYOKPcpwrYzpseDKfmRayFHOW/NmCE98txh4R6s1UMQ
         bFTy5Obs9Ew8LJIozBwxaAPe/nj+IvuuuIxqDmMUwsfTJ67ZZOe8Z2I60I5IPtWywd0i
         YPMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=aAs8iRiZBNjQQ2FpDAsqfhnKTgizd2FKSQYKAcq4guM=;
        b=kL6tu+Pe80zkdGNjdh+3jE0pfC4EFvuCwdPks5PIjRl9E6Mqfft3iNiKvCZ8eQpf2M
         lWq3tdmY3yO0/nK3oVJyV0n+fDvtXO/PCoRMSeZBhR0PqD8fRNttgVBh3q15ShfZv3Es
         hudu5qR845CURYlwOtdlqJB3hTRep+08oI1/Xg7ch1ikLjozYJGiV4YTuLiyhjDw+3Fi
         nIDpm21WuCOIggnTCd/et0WzubhVwaMwcx0rX91ZAgFNmWbuQ1IJB1JuPr/CYBnLQbgN
         LDTqtnwmeTZybEJ5fe8gRhj3CLfpBd9qZM0yaWDBUcJf8vVngJcLYeYpPFDpWb1pr31E
         m+JA==
X-Gm-Message-State: APjAAAWGA1EfwGf8z9oz7hXc2uugC9HtYSoxQV3638/GMoP5Z7NhWrly
        UewGMrv5VfTHV14BQ4T3izoiVg==
X-Google-Smtp-Source: APXvYqz79Fw3y0rJXmzE8oREQGw2j5KSOM+rNXWGkD35BoxELEesSJ3Q8KqO7S2OtVy1CnNJsU4PGw==
X-Received: by 2002:a05:620a:20cc:: with SMTP id f12mr6377677qka.472.1570666416505;
        Wed, 09 Oct 2019 17:13:36 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id h2sm2049535qtd.14.2019.10.09.17.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 17:13:36 -0700 (PDT)
Date:   Wed, 9 Oct 2019 17:13:21 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: Re: [PATCH net-next 0/4] sctp: add some missing events from rfc5061
Message-ID: <20191009171321.4583316f@cakuba.netronome.com>
In-Reply-To: <cover.1570534014.git.lucien.xin@gmail.com>
References: <cover.1570534014.git.lucien.xin@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Oct 2019 19:27:32 +0800, Xin Long wrote:
> There are 4 events defined in rfc5061 missed in linux sctp:
> SCTP_ADDR_ADDED, SCTP_ADDR_REMOVED, SCTP_ADDR_MADE_PRIM and
> SCTP_SEND_FAILED_EVENT.
> 
> This patchset is to add them up.

Applied, thanks.
