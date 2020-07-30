Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72841232EA3
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 10:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729062AbgG3IZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 04:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgG3IZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 04:25:13 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEDEC061794;
        Thu, 30 Jul 2020 01:25:13 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id df16so2971025edb.9;
        Thu, 30 Jul 2020 01:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DJxfTFvC3hUmMu3XHLkhRUumg4gnQJ/KBa/k8zUvYyI=;
        b=UnCTJLAzGnQ/m1ceoQ5nR6nP9lJGdGB8cVstYbJAaJZjpkRKlkaYm9ttsVyJy/cD1m
         KWcpbpUXhv7JySWBjC+qQZJy+MAfWFSlVEmqaAbBjn9Xt+eJ+i0ZndaWnVJyLHZFxMp9
         DT7e8ptOJDC/Hsl0VxRHXSxdJxJpVFRM9jjb1sx4g9F03CQ/+5og/r7bDHF9QOCNrT8E
         HUAW1QPduCfgNtWpLLhdzBC3zPHax5jvCtPj6WtFmiJ+eGfOD0dwD0nMVOX1GPqvuvYT
         p1jn7a41TxmTfwYELhkF4hqCXkLvu8kgSlsNM8wBZC6FPsrjWNiswbSQkI5y/VOKkrNT
         mcnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DJxfTFvC3hUmMu3XHLkhRUumg4gnQJ/KBa/k8zUvYyI=;
        b=TZY9EJPbp0E0OFz+u/FOt7oy5xcN2MC5cY0dS6XQPfXCdiGr8L+9QhLCmGskeXspTi
         ULahG/Cc3OOi/Uz1uc0yulCkLzdSYSfYLT1WdLGy2hXM4sSH9Lgl+gNcLBQKt7I7N60O
         cbJpKFJ7LBHLn7Flv+iCNIxZOq9k5drK5R4wOqjec8konUWtmOxY21ezocuAWqYlxAgS
         vgY1cWZ9C5XJ1+TkS2qPd+bPjV1XBg8WdPQOA2HirOh8JU3mLa0qQJPpEDF4FXmpXerR
         iUxI5eAWMWXuwq4i+TXbAp3H3NvOfM/hR/9RZ64NnRu63lfJHnogRlC1HY4zQ7YD8DTx
         8//w==
X-Gm-Message-State: AOAM533GOAZYMNzBTCj+JDPRRdSzZ66Z/anLIdd3ECi/J1Wt1nn7nY4I
        aDAw3eJ0HmiqRAlddUa8dm71uyKh
X-Google-Smtp-Source: ABdhPJx5E9kBhC7ffMIfFvxTok1TBdg/8bFbTDJhlHOumSB+EQkYDF93CC7J7lSg/YqzZYoYTi79tQ==
X-Received: by 2002:aa7:d6c7:: with SMTP id x7mr1543213edr.167.1596097511859;
        Thu, 30 Jul 2020 01:25:11 -0700 (PDT)
Received: from skbuf ([188.26.57.97])
        by smtp.gmail.com with ESMTPSA id k18sm4863078ejp.81.2020.07.30.01.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 01:25:11 -0700 (PDT)
Date:   Thu, 30 Jul 2020 11:25:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        madalin.bucur@oss.nxp.com, camelia.groza@nxp.com,
        joakim.tjernlund@infinera.com, fido_max@inbox.ru,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 stable-5.4.y] Revert "dpaa_eth: fix usage as DSA
 master, try 3"
Message-ID: <20200730082509.4543oou7lozdmbjz@skbuf>
References: <20200624124517.3212326-1-olteanv@gmail.com>
 <20200730073013.GC4045776@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730073013.GC4045776@kroah.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 09:30:13AM +0200, Greg KH wrote:
> 
> Now queued up, thanks.
> 
> greg k-h

Thanks Greg, I was wondering whether I should be reminding you or not.

-Vladimir
