Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F951AF07A
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 19:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437078AbfIJR17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 13:27:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59832 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732988AbfIJR16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 13:27:58 -0400
Received: from localhost (unknown [88.214.187.211])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E1130154FE282;
        Tue, 10 Sep 2019 10:27:56 -0700 (PDT)
Date:   Tue, 10 Sep 2019 19:27:55 +0200 (CEST)
Message-Id: <20190910.192755.717621354475214603.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com
Subject: Re: [PATCH net-next 5/5] sctp: add spt_pathcpthld in struct
 sctp_paddrthlds
From:   David Miller <davem@davemloft.net>
In-Reply-To: <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
References: <06a808c98b94e92b52276469e0257ef9f58923d0.1568015756.git.lucien.xin@gmail.com>
        <cover.1568015756.git.lucien.xin@gmail.com>
        <604e6ac718c29aa5b1a8c4b164a126b82bc42a2f.1568015756.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Sep 2019 10:27:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon,  9 Sep 2019 15:56:51 +0800

> diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> index a15cc28..dfd81e1 100644
> --- a/include/uapi/linux/sctp.h
> +++ b/include/uapi/linux/sctp.h
> @@ -1069,6 +1069,7 @@ struct sctp_paddrthlds {
>  	struct sockaddr_storage spt_address;
>  	__u16 spt_pathmaxrxt;
>  	__u16 spt_pathpfthld;
> +	__u16 spt_pathcpthld;
>  };
>  
>  /*

As pointed out you can't add things to this structure without breaking existing
binaries.
