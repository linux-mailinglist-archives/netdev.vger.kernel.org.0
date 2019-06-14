Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5B3A45790
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 10:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfFNIcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 04:32:50 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50815 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbfFNIcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 04:32:50 -0400
Received: by mail-wm1-f66.google.com with SMTP id c66so1417439wmf.0
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 01:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dvI+opR7Gl9wqWYDbFu1qo/JP3Qt/7RbK3ACHTqT3cM=;
        b=HyjYBPbJJUxqg5Q/AEJZil4WcqdYxl4NlD5crFUEeyi0uwLjVLGvnl353sVSt9+W1Q
         2E1RxEAGsW32wMOFt/Pm9ge7Z6yjxr9tMuYzAcHygNelKKt8nCTTj/WI5cOuM7V+2YkM
         DSAq/zXRNU2nzjhB9jGJP++8++0ZimNmCzj9Egm6C1c0LZyIUIToelLeE+CanENWzH5Z
         q+7uWMkWUw5/23drTyLtGg3onW1/DQPfHb07uu7ygwJkSevW1D3EeNM6lxva/hZe0o1V
         rai7xhZB+OBXuezP9Ld6AZW8s7AhTONL95kCKTOGahbsNRYnsQPr1QkGzIKukL2O93HC
         mBtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dvI+opR7Gl9wqWYDbFu1qo/JP3Qt/7RbK3ACHTqT3cM=;
        b=F1+1KUcjRgtd9KAvpnVdnYq3o1iwCtoenhoRu+PSXSw039gCWj7CalXQMPG8bxRDT+
         kmvQyJaQ8q4JEz5lnQTUo1idWANZNbT+RDrEIkxeLpQPvkcZrFoHJFlk8OhO+ZoBdwyq
         mlLAGlfkX4/d8bWycVi686PdVH+bPMXWl1V+PeEZnImaa2b9+UfCc1NnLkiVakw/iATe
         iy2w1p7Emn4tMJLxwx63vuQDlgfybxvbIYjCtATM4ftaRM0psNbuhuZCjxjLcVYXEso8
         zHIkuh/mcSIfJIALjVwSYeU0EhaLU9yslOxuLIK+NtwI6hCCgVRMwyNKzLPn8cyqhE5/
         2EJw==
X-Gm-Message-State: APjAAAXVClaQSqwx4TifF5M84Ud3M4FwjyMjPf5xdQdc20quwUuVcflN
        F8etXS42PesGlPtcr5YE7mXB/1V/sY81zw==
X-Google-Smtp-Source: APXvYqz/YWOTgY9zg6+c6mbGq714MB1TVIp5pKI1CGkWJj6mET3z9q/sbAo2eElKaNDQD+M97VvvGw==
X-Received: by 2002:a7b:cc93:: with SMTP id p19mr6813400wma.12.1560501167936;
        Fri, 14 Jun 2019 01:32:47 -0700 (PDT)
Received: from localhost (ip-78-45-163-56.net.upcbroadband.cz. [78.45.163.56])
        by smtp.gmail.com with ESMTPSA id d17sm2918601wrx.9.2019.06.14.01.32.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 01:32:47 -0700 (PDT)
Date:   Fri, 14 Jun 2019 10:32:46 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next] team: add ethtool get_link_ksettings
Message-ID: <20190614083246.GF2242@nanopsycho>
References: <20190527033110.9861-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190527033110.9861-1-liuhangbin@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, May 27, 2019 at 05:31:10AM CEST, liuhangbin@gmail.com wrote:
>Like bond, add ethtool get_link_ksettings to show the total speed.
>
>Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
