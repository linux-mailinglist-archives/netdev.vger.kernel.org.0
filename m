Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3EE47C9B4
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 00:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237217AbhLUX2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 18:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237169AbhLUX2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 18:28:36 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3D4C06173F
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 15:28:36 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id g22so416610pgn.1
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 15:28:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+duxhmdjmHJmuC2AJdPjI9r4uObHqi7Y231W98U5DlE=;
        b=pI5XejUtvgbB+Am1cHjU2cNS/JYLNcM+LjYtDgnb7fIe7CIU17mlodQugQqtxMTii7
         YILnBnEcFk1d94EeHS9pteMGJyDJ9BVWEbWJPXeK9hhwGb5B7bJCe9zUa9PjdlapF0Yy
         inVvItBczcAQMuHlOuHScUdy9zTao8a88LyO9QnZL2i/MB3bGw9HkKK7ceSy2yuccchA
         f+Hb9fqO3Lfrr48jTs8cuzYVFZUsxGE5z7KhYS4h2v7kMrxTwTAB+ryPbtCWKutc1JU0
         Se4+oVYv+z8vl8a7irJHnc56WnlIv8aCMnl/kNQfAqjkQU89FeyUJhnUXqupjLgVZWtn
         eq9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+duxhmdjmHJmuC2AJdPjI9r4uObHqi7Y231W98U5DlE=;
        b=lyqCKHdNJin5bNPOH8fmQYsIL6eoHlm2BjeZTKNwJ6cxjdd2YSwIXXKiD5QsS1z1nC
         C/6YA+I/y+YOZ0d6vuTXEmMJrvP1oXSZDlZoIuWQKYUZg8DBzvEJAuTd/Q6lsVo/T64Y
         O1bsznNbCePzEY6Imeg7A/kAguaGwt9L80DwYb5sZXx4hMxAWDZWCOPx1eblGPFxSrfV
         rZSviP7lkhLDfuByILNpITBRhFLqxiYNBfTsv/ReCDibxN4rW2YpUxY6vO+iKwky4QBU
         zUdpe7+3y35xW0BeriG0SEk1967LnYRUaBRHpR58FZtqp721g9wYR+u4OPclMVwtHnVo
         FJ/A==
X-Gm-Message-State: AOAM531A9AE5KcF80Kp8ech5aLV3VDfFXadbezSS8uyoqiApYayrnJ9S
        0u3R6Mx2TvK24eNxeqXDKHg=
X-Google-Smtp-Source: ABdhPJwWN7xIqfQTMBeN8Ws/48CwDsDgW5HxSUtHPRTLLr/tv31gm9YCjQ4qnv2iYSFWTUSn/Ggj5A==
X-Received: by 2002:a63:354c:: with SMTP id c73mr532008pga.532.1640129316237;
        Tue, 21 Dec 2021 15:28:36 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id a3sm176544pfv.47.2021.12.21.15.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 15:28:35 -0800 (PST)
Date:   Tue, 21 Dec 2021 15:28:33 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/10][pull request] 100GbE Intel Wired LAN
 Driver Updates 2021-12-21
Message-ID: <20211221232833.GA15734@hoboy.vegasvil.org>
References: <20211221174845.3063640-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221174845.3063640-1-anthony.l.nguyen@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 09:48:35AM -0800, Tony Nguyen wrote:
> This series contains updates to ice driver only.

For the series:

Acked-by: Richard Cochran <richardcochran@gmail.com>
