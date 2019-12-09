Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81C7D116D1B
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 13:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfLIM04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 07:26:56 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:45907 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727232AbfLIM04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 07:26:56 -0500
Received: by mail-ua1-f66.google.com with SMTP id 59so5467599uap.12;
        Mon, 09 Dec 2019 04:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GR/v6DUGqaULo/B/oQwLfkHpgSOdsvLv1UJn7fEC4TQ=;
        b=bUGCFNAPbav+EnraGfZIu/LE0E4oFB4GgeoKv6//fTRoPRhFOqVbsUQYslBMYLc136
         YMZVSh1cO1/GPMIzJE+UKQi6oIjaQjNzbboGdnXl/UKVIM8cEuCTCtCpnqhw1oML0X96
         pO7GlWJDT5B/bQ2QNDTShwD3wAJHgb5YkKdTxWUeRXhBIssDIMc4e6YhlZv63/mqDHuA
         PxZ1tYLGu3ZhSZ9FXloPCZmP3jBrAh6IKkaB2ixnJSh2mfFzGJTAb8w0+zL0i8jh+pWn
         PfkkYhGnuqoox6g9uU58yaVVN5hyqSdMGfAnQ4wt/xDJXT0kuolPB/NhS00q3623mfcZ
         W5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GR/v6DUGqaULo/B/oQwLfkHpgSOdsvLv1UJn7fEC4TQ=;
        b=UZdP5a+a6aXcgNrJMD5G8CXcl3PH0an/JuIxghQdZVMkt5WwhW6GCVpdkYvlml6XEQ
         ieauSrhGtEe7uhUA+R0BinoOEntlDnICX1bobFaZHCai39WlaOxAhYYZA+mHi49Dh2zB
         C3FblNiG7EAxExhoQYP2uxHyj8MqxcahXyyM6hHF40GCyNt2u6x0gV++gnOIhHBOXoh6
         ACNobGDcf5WWw2Cv4kuEprYtjFWXGKouqIEyPR4w2gQnmnCr731qS2eanCf2+CuOjp7w
         zZcviyljY7GR1PkQMDx2cqIHoP/QVVHRzgcxrBALFHgIlLyZzQqnaaiuA2bEZedRiwzj
         A2Ew==
X-Gm-Message-State: APjAAAUn0dGgIpiUWTOo4iRUVaP75DusmcEPous4NN6uZGGDfuvwC0Zj
        SZVgDDXIxCW+l+dP5ZuKhxI=
X-Google-Smtp-Source: APXvYqyK3LxORK6NLrkR2yJEBlXHsvLs+Rc2o3KdFAxtLpJsEtp+RxO4XfNsj4jlfGTxz9ZWaVQ6kg==
X-Received: by 2002:a9f:3fcc:: with SMTP id m12mr24081865uaj.89.1575894414619;
        Mon, 09 Dec 2019 04:26:54 -0800 (PST)
Received: from localhost.localdomain ([177.220.176.179])
        by smtp.gmail.com with ESMTPSA id g22sm490118uap.1.2019.12.09.04.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 04:26:53 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id C1552C4DF2; Mon,  9 Dec 2019 09:26:49 -0300 (-03)
Date:   Mon, 9 Dec 2019 09:26:49 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCHv2 net] sctp: get netns from asoc and ep base
Message-ID: <20191209122649.GA5058@localhost.localdomain>
References: <76df0e4ae335e3869475d133ce201cc93361ce0c.1575870318.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76df0e4ae335e3869475d133ce201cc93361ce0c.1575870318.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 01:45:18PM +0800, Xin Long wrote:
> Commit 312434617cb1 ("sctp: cache netns in sctp_ep_common") set netns
> in asoc and ep base since they're created, and it will never change.
> It's a better way to get netns from asoc and ep base, comparing to
> calling sock_net().
> 
> This patch is to replace them.
> 
> v1->v2:
>   - no change.
> 
> Suggested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
