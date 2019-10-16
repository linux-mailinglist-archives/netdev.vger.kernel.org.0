Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A03A1D9942
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 20:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394286AbfJPScQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 14:32:16 -0400
Received: from mail-ua1-f48.google.com ([209.85.222.48]:41449 "EHLO
        mail-ua1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728639AbfJPScP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 14:32:15 -0400
Received: by mail-ua1-f48.google.com with SMTP id l13so7549679uap.8;
        Wed, 16 Oct 2019 11:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YUT++8D8Qi8z3/wD/OnfZA6rhhQrGRbMd4EnNFKtyQk=;
        b=Y7pegSiQfW5hMcvzKSr83vtkv/0WNdchX5s9JlXMT+Qg+xP1ujB7CVSNaWI+TgUh6b
         6xbCh/2wcSYj/7Fb2TPgtSvDX+Vgs12y5APq8U7GrJE3uLwQWKfrEHo87/8y/bwkA4G4
         BFzmK5himgEGUh8S9Z/6EdnCDm9oDV7Vd+u70/Nd3lbAURls+RNb6CJu+Fccahbf5K26
         ZdqJbRt4RYEUPY7qXK2S6THnmeVizIrWKxhdco/G2lXKsvbXNtlgZ5YYqoHKDep0dsyh
         bovbVgPhudYZdaiRs3Vc0uZVcF9nnNJKn2xWfgWk6JTo4MBj3WpIhrKaDtJ/3AUdLRPR
         mRJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YUT++8D8Qi8z3/wD/OnfZA6rhhQrGRbMd4EnNFKtyQk=;
        b=SeSI/HnBlTC78uRgokiITjKcclXcs93jXZzoIwjZLRobIhEr1yJHwUxv62OwXreQJ9
         lilVF0BuHoO0L6uJL2KcUgEFZlbuUbS0/ROHJllgr2xRaVPkvZN7OB+KJhTyJ61g1nFf
         VHpOu6o0Cd1ySb5s684WBIPuWmHFMSGQbp0FyWJpdugWtVUwNppWeGR3k4AZ+jZK1anH
         wNBbgYPLr0z7IzP13siRjct8QZ9kSEX6YqdrAtQxfExUfZxgdpz7Kj2Fwr6Sup61R5QN
         NpBm1GkUavbC786ERI94dUXlA3RgVdI0Y/XnvfMlXo0y0Bn5dsXiOYWQE53l+aH9qzI7
         cVng==
X-Gm-Message-State: APjAAAVpn56Gzmaml+1gGyh+fgvhAN97LyZDL2LERJ+GOiAQjRA1QA8v
        LrujDNyjxrJHEcFFZrRnd3o=
X-Google-Smtp-Source: APXvYqyAwtV7BvHhpn/stwEtBQFzLfMj681seimgIo3hmEI1+rXj0y3K4zvY+ZPM+CYvK/vjWrEMzw==
X-Received: by 2002:ab0:7008:: with SMTP id k8mr16907214ual.70.1571250732923;
        Wed, 16 Oct 2019 11:32:12 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.217])
        by smtp.gmail.com with ESMTPSA id r22sm5594579uan.13.2019.10.16.11.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 11:32:12 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id A7E4BC0873; Wed, 16 Oct 2019 15:32:09 -0300 (-03)
Date:   Wed, 16 Oct 2019 15:32:09 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     lucien.xin@gmail.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, nhorman@tuxdriver.com,
        david.laight@aculab.com
Subject: Re: [PATCHv3 net-next 0/5] sctp: update from rfc7829
Message-ID: <20191016183209.GA4250@localhost.localdomain>
References: <cover.1571033544.git.lucien.xin@gmail.com>
 <20191016.142534.1360443052637911866.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016.142534.1360443052637911866.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 02:25:34PM -0400, David Miller wrote:
> From: Xin Long <lucien.xin@gmail.com>
> Date: Mon, 14 Oct 2019 14:14:43 +0800
> 
> > SCTP-PF was implemented based on a Internet-Draft in 2012:
> > 
> >   https://tools.ietf.org/html/draft-nishida-tsvwg-sctp-failover-05
> > 
> > It's been updated quite a few by rfc7829 in 2016.
> > 
> > This patchset adds the following features:
> 
> Sorry but I'm tossing these until an knowledgable SCTP person can
> look at them.

Hi Dave,

Maybe the email didn't get through but Neil actually already acked it,
2 days ago.
  Message-ID: <20191014124249.GB11844@hmswarspite.think-freely.org>

I won't be able to review it :-(

Thanks,
Marcelo
