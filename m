Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E73244882C
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 18:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbfFQQDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 12:03:09 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:37801 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfFQQDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 12:03:09 -0400
Received: by mail-wm1-f52.google.com with SMTP id f17so7201984wme.2
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 09:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iID5eFDNiV7eVDI0LY3sswpccWDwMJWnlwxPQA8C1M0=;
        b=m9EV7mTeleGxwtucjS8PaTBDIKBtCwPxWMK1xsz4Kn3vMIwxshRuv0tH3q9se12eTK
         P++v76Rxx+wGDmzUdW36PPyfzVwOSBpnQ747lT3tGS3NwEb0Bz1dNpo485p6sN+lARsi
         AoxPuRsY5rP1Mq5xS8v3534bByd0kk0aTxGF1urpQyKCp92KJlF/sNX0vv1cwisHV8TF
         xr0Ds7QeoWdSmQPHRQ8CUPTnijmDYKyboMmQT8KgROKYq1cSN7q94MngvMtCWItAVC9B
         B51WeO6+wSk+5qllDNB4W3W/WW/pqt3ABt9wjwiWI5e2/jx45YtWF3hoDoas9bgzLWlm
         B6aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iID5eFDNiV7eVDI0LY3sswpccWDwMJWnlwxPQA8C1M0=;
        b=ZrF2pAOJLF/FCDWSMFuzaNcmEESUD+2g2zXloTb/iWAU42QTa3fBI5e8w9CjHAicZg
         1n5lHXwR1pP4tU767jw0v7eYZtENRcth1idigAZAGE1uXcJAp6aVF3RbokBMkDspQqcC
         vajOUMkrBEBubRUxKmlqHgJ6rp/nYqM/sYaPe+AowBzd7D7OHzKGGEdEdncR2h1d4zTn
         gVrpc7JB4iMkcHgbDV91/6PznFP2ammRu27qIH58ZJ1a9jcIMF6YVUhCOJP56Pdf9yYQ
         zfSbpQe56V5YSBCQntwbOpvqE9xRVLJLAIR16joSgIo7t1ZRo+N/2rRVCxRa3GH4KLfh
         EP1A==
X-Gm-Message-State: APjAAAU/UdV01RVULaRKiDoCeV/DQL4DFypv7dpta9xxTvJFMgSuSn1i
        YBsdShAtTPiUOZdbDIlOFw3y0NcDIdc=
X-Google-Smtp-Source: APXvYqyad8vq+MmK1Ngs+ZfXWBPnqeh43A8g6M+2KVaPhbtXewnr3feb1ZG7zvP/mf54qTyFH2+0TQ==
X-Received: by 2002:a1c:acc8:: with SMTP id v191mr20297741wme.177.1560787387210;
        Mon, 17 Jun 2019 09:03:07 -0700 (PDT)
Received: from localhost (ip-78-45-163-56.net.upcbroadband.cz. [78.45.163.56])
        by smtp.gmail.com with ESMTPSA id b6sm11809849wrx.85.2019.06.17.09.03.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 09:03:06 -0700 (PDT)
Date:   Mon, 17 Jun 2019 18:03:06 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com, eli@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com
Subject: Re: [patch net-next internal] net: sched: cls_matchall: allow to
 delete filter
Message-ID: <20190617160306.GB2280@nanopsycho>
References: <20190617160208.7548-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617160208.7548-1-jiri@resnulli.us>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, wrong prefix, please ignore.
