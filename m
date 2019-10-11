Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59DFAD46B5
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 19:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbfJKRff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 13:35:35 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:33239 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728461AbfJKRff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 13:35:35 -0400
Received: by mail-wr1-f44.google.com with SMTP id b9so12854614wrs.0;
        Fri, 11 Oct 2019 10:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ldn1+y4i+TM+l/Cu4HtEy/jFbE45xXljUNQey12ghIg=;
        b=Zs2H82o4DqF63IDhzoBFLmddb31FxW0PjesX4lLX87MmDlERw56C4+lJxly+SyMPAz
         PGUsRU6sE6/aU4CzGCBRoSNFQajdav8CSNoZTVGx5AYrigEUBYkmOvyFmZZ3dZYWTuIi
         m7sBJuLLlGhQ8krkYeGvATfvi96AbbAWdYtG0H6rMWVcnYlmCwCxYl3JsgOjtUB/7U9i
         QM0LQzc5Mzc325Muz9LJpZU3uzc4gQj6MjF+aEOPpjRb2VNk4usKnLUHfXvv6KszKc/C
         oWJffYE2VnWLeMrolSwwRUxqFPyTshE+RyhbjmishCoQOlSHVLYGstv2PA+cRy2oY9NF
         mbOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ldn1+y4i+TM+l/Cu4HtEy/jFbE45xXljUNQey12ghIg=;
        b=Wo/iiFSYN88PIYRF9nowa/5N2Sx5EJzXYs0P5NFh4nDrx9aVUf3QFxKWIj5/4EdEnP
         sEXx+Rkn9pW35pzp+TKJBbVGB4uykIeYU2OscIrVqFtS3dltl/UHwC7/Xun3FhHBLfYQ
         wsy4rfTUArpVwtNrhTuiv/r6VwNwMqH1PPP3lOvQQ+l4ZJ74B5hK6ySE3eGsRmXW6eqZ
         Xb5PnTynWrcop4pTu1tyR6QUZbG1aYTypCKUuUMQxbRfWZl3WIrTTRJfHR+TjPfO4sX6
         qqNUC9rSEA39pqRk+xbuRg8rwqgSK4roAqNsirl0IV4GUgdcHydc0ssssFQgR9pQyOf4
         TZ3Q==
X-Gm-Message-State: APjAAAXUG6xh3wlyoTxeV5yYEUACCm1JE4NZ2MC3t+DlTw3+dfkMOnEs
        7kUH426SExce2npH5xXA36c=
X-Google-Smtp-Source: APXvYqxL1v1bOAqXNayHLgr3O+yDOlR9ISOlJHTaBPGqrem9ZzTj7AtxPsmXFyS+6Pqw62fzU6mQNA==
X-Received: by 2002:a5d:43c2:: with SMTP id v2mr8911335wrr.153.1570815333323;
        Fri, 11 Oct 2019 10:35:33 -0700 (PDT)
Received: from wambui ([197.237.61.225])
        by smtp.gmail.com with ESMTPSA id a18sm14506877wrs.27.2019.10.11.10.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 10:35:32 -0700 (PDT)
Date:   Fri, 11 Oct 2019 20:35:27 +0300
From:   Wambui Karuga <wambui.karugax@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     outreachy-kernel@googlegroups.com, devel@driverdev.osuosl.org,
        isdn@linux-pingi.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] staging: isdn: remove assignment in if conditionals
Message-ID: <20191011173527.GA22796@wambui>
Reply-To: 20191011110019.GC4774@kadam
References: <20191011072044.7022-1-wambui.karugax@gmail.com>
 <20191011110019.GC4774@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011110019.GC4774@kadam>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 11, 2019 at 02:00:20PM +0300, Dan Carpenter wrote:
> This ISDN stuff is going to be deleted soon.  Just leave it as is.
> 
> regards,
> dan carpenter
> 
Noted, thanks

wambui karuga
