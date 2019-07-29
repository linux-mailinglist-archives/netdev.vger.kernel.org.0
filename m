Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA69E7911B
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387631AbfG2QhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:37:12 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37230 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727314AbfG2QhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:37:11 -0400
Received: by mail-pl1-f194.google.com with SMTP id b3so27742544plr.4
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 09:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=rQNwVWhr/iAWO1h6tJ7DvuuxwYrEzjOkIjTIxJSwEeM=;
        b=CzxJQ8DfEZgEgBpwt3AL5iNRX2dHKgYQ2l1Fdl9DjYxLKA9QEjfLSAuwQ8f4ble5pp
         w3UhiYarfOQ6+3GwSpTqL1Nq6uiAt3NJBW9hqig7p/QWWjE53iA9SjYWtQ0wqqcC71FU
         emdUecmyeMSXHAIs044VY7RhUmspvRPwEOfql2Nz7iE9n1X/MksTH5/z3UV5fpuFTvuV
         DbbF2jPQkVNTfA2ZOmRfatcF7vbDefGpvhk8VxyBKVu3YuXaw5tX9nhcbM+vtSE0MrKA
         SP/500QNfGzgH1dEsfScd3Ff66xKZ2KqeLsRKVG0hc2XOmON+Gag3SQOTzYHYiMks5vk
         /aMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=rQNwVWhr/iAWO1h6tJ7DvuuxwYrEzjOkIjTIxJSwEeM=;
        b=D+u7MfIBELJjIy5VdiSOfjIC/z2cOsqMJm7gvWxOjcs5ynYTz8obab9i8Kup0MSF4Y
         I4KlBBlOXB99uSQU+RIG0xIJHGeGKW0D0qQ3p8BprfGu5jUqXDsxyVVZLHqq+GQL+EbZ
         tV+mr7r2VAwq5Y7HGtGMBGc3qfsEjRNWcxibGLSeQu7dgwepNsLtNz1BJaru9C02Ymcl
         ssBrIpcvm3Hf92MjfLzwJP/bVz+vBkLdjPmBCVZO7tLGeFKa+hcabGEM7hq0aNCXrEnF
         2kFOPa8BRrkyaU0/8V+le53bK4en+4zYb4qtMj5zv8qhW13WoN91r0GOgwRiBwn/lmoF
         avSA==
X-Gm-Message-State: APjAAAXVp98Hi2uYhA/4i2ckdpjufG+shMwv8JFKMBU5Z7M2laE6CZvP
        IvSPtfXfqQp129en8Rwcv7G3zg==
X-Google-Smtp-Source: APXvYqxf5IrbxRXrgplVLx4tyGUqrNJe0VLQyF/nrJYjVyVRsG6XN4wmnW0oV3rs7b+I53AKL01jrA==
X-Received: by 2002:a17:902:59c3:: with SMTP id d3mr107721634plj.22.1564418231023;
        Mon, 29 Jul 2019 09:37:11 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id h11sm62978725pfn.120.2019.07.29.09.37.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 09:37:10 -0700 (PDT)
Date:   Mon, 29 Jul 2019 09:37:00 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     xdp-newbies@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, john.fastabend@gmail.com
Subject: Re: [PATCH net-next] MAINTAINERS: Remove mailing-list entry for XDP
 (eXpress Data Path)
Message-ID: <20190729093341.2bdb04dd@cakuba.netronome.com>
In-Reply-To: <156440259790.6123.1563221733550893420.stgit@carbon>
References: <156440259790.6123.1563221733550893420.stgit@carbon>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jul 2019 14:16:37 +0200, Jesper Dangaard Brouer wrote:
> This removes the mailing list xdp-newbies@vger.kernel.org from the XDP
> kernel maintainers entry.
> 
> Being in the kernel MAINTAINERS file successfully caused the list to
> receive kbuild bot warnings, syzbot reports and sometimes developer
> patches. The level of details in these messages, doesn't match the
> target audience of the XDP-newbies list. This is based on a survey on
> the mailing list, where 73% voted for removal from MAINTAINERS file.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
