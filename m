Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54E8F579C9
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 04:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfF0C7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 22:59:20 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41770 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbfF0C7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 22:59:19 -0400
Received: by mail-qt1-f193.google.com with SMTP id d17so875253qtj.8;
        Wed, 26 Jun 2019 19:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JgAltzXr9FQ/hdvBeX9kjz80TpVTlYDJkYThTew7RUs=;
        b=jv8DLAOc+URBh863BaCrNY/BwVcx/aRK5uxRiDpV9mSjiZ/CoD1+Zz+LQMqOAgs1+t
         Qd9oywGzB+x93QEb5QbVqKKXmMflMOlSyrjkndl83G8MZp0bLL2IyfSAJf+aotRe25Oi
         mTEJ2hjHrgry9LsAGextYsOGbpBcezscJwQOOxoTdWXZmlpM1cyqoe23Firhc2EKeYEg
         9/l7q0HcI+Cob7tzteK9LlPYC2lRBWcBIkg0JziSUKqjPNloN4L53ImlNiyIzRPFdtRu
         MIeJTUfv2wLI4iA4ulnssA8sDwTo0DqkjuIsWH/pf5DioaTIUBGsea/Yjhn2cSx5pPRn
         hAtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JgAltzXr9FQ/hdvBeX9kjz80TpVTlYDJkYThTew7RUs=;
        b=OpN776x1EQXZB7tzVERsmzllHkZAC7Pc+9MpulQFu1mmir9piJ8PcCJ7PxuarA4dQV
         QdFI4tmhr62sgfci6mBc290QINAnI6kz/ZwLxt7z5YDbAo7UbW+wM/QySFF6SyP4JYE6
         Xi1yf7VFulWNPWR0uOAR75w518LomDcJDDhPIIOTD4ns0nRUloY1bVDBQFLZSQ2qNSjf
         UvENuLsJ+CrshAXd3eOCmcAGiRUTDaT5dSGhOLTKrbUvlsg6mMDHta++V5m+eQfV4yC0
         GOjHXD6nn32yPXyuoUyTt46RdTlN6c5tm9SiHh17UQKaGJUB5o0CQTjt+dkWeAs6ouif
         HgpQ==
X-Gm-Message-State: APjAAAWhK1bgCoeBmx2VOGyKcYuGTmX94n/RmXmJeeoJ8E6I4L5y+nVC
        Arrp5HfKZeUIE0oGdZOnQgk=
X-Google-Smtp-Source: APXvYqwiXcMFT0KrSZZ0BSmlxUPsk1FFxJKokAuRRyuiHdu/KgUIx2ESPbnaHqKo8Yr5Y1cyGnWU3w==
X-Received: by 2002:ac8:f8c:: with SMTP id b12mr1060376qtk.381.1561604358470;
        Wed, 26 Jun 2019 19:59:18 -0700 (PDT)
Received: from localhost.localdomain ([168.181.49.32])
        by smtp.gmail.com with ESMTPSA id e63sm334321qkd.57.2019.06.26.19.59.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 19:59:17 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 26BC6C1BC8; Wed, 26 Jun 2019 23:59:15 -0300 (-03)
Date:   Wed, 26 Jun 2019 23:59:15 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH net] sctp: not bind the socket in sctp_connect
Message-ID: <20190627025915.GA2747@localhost.localdomain>
References: <35a0e4f6ca68185117c6e5517d8ac924cc2f9d05.1561537899.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35a0e4f6ca68185117c6e5517d8ac924cc2f9d05.1561537899.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 04:31:39PM +0800, Xin Long wrote:
> Now when sctp_connect() is called with a wrong sa_family, it binds
> to a port but doesn't set bp->port, then sctp_get_af_specific will
> return NULL and sctp_connect() returns -EINVAL.
> 
> Then if sctp_bind() is called to bind to another port, the last
> port it has bound will leak due to bp->port is NULL by then.
> 
> sctp_connect() doesn't need to bind ports, as later __sctp_connect
> will do it if bp->port is NULL. So remove it from sctp_connect().
> While at it, remove the unnecessary sockaddr.sa_family len check
> as it's already done in sctp_inet_connect.
> 
> Fixes: 644fbdeacf1d ("sctp: fix the issue that flags are ignored when using kernel_connect")
> Reported-by: syzbot+079bf326b38072f849d9@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Please give me another day to review this one. Thanks.

