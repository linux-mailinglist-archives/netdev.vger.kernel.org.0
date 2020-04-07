Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 418751A09C3
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 11:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgDGJJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 05:09:39 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:39067 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbgDGJJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 05:09:39 -0400
Received: by mail-wm1-f52.google.com with SMTP id y20so987901wma.4
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 02:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TuUC2ra1KKoT9Ylg5d3F6xK4m9KCbv7xP2Gshm4IL78=;
        b=cwydD1807X8E3QCWZNbHoYbdaCZWEifdJZjaJiJNoyxQHFPzYSB9e6tYCfztTAGIKL
         ZjgDoLErO7wCY5ELZgvZV1NuOUjLtv36VyQ4Vhl5ot7EC5DBU535XBWuDWoVxiMAhafP
         dzsFC3XM2zFILIVEdFNQcMfVoK0MoS7lLamIuQX82JzGQb3gT4rJ7ENPH0fZATq6yDSG
         So1fq/rXvPy13SECfS6dgIQwYUxZRiBNPAJwGjYcqBBCK784Du+P+/mz3E9ep4jInVog
         nPGYRHDkhTyrTnA1qsQaD0A0+erPEiaNKoRKE3Vl0NmUYBJhu12iFitLVzbIZunzISHZ
         z1tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TuUC2ra1KKoT9Ylg5d3F6xK4m9KCbv7xP2Gshm4IL78=;
        b=Qg90329U6gT1fYnsIu/eIeb97uKNJOwCYbTW+Gk0ayqrBfnO2XQDiMFIaQdd58WUY1
         dcHmnuN52y/69BGyf/rZ95xVLhzTD4/R/Nz3xcmrBcWGyU9zQ77RdzlBR9wO0vjOur7v
         Tp0IoiwNinNMOTJLxAcQYwRZQkY7cduKtXXZa80OF60JHJFOtIeuA8TCX0XtUztLG+H8
         xQazAJrpTzhN/aBQ8OBUKekNbbrgYt0IwhrD+mh410YVrsSRTotrUZY0Q3iy23N77mos
         cCyWIs2Q9Hq3a7wauBp+Xbhpp5HtlqxXY0xMa5+YPMysy6qk05LbwwHwxJl1OwEbx5cQ
         O7NQ==
X-Gm-Message-State: AGi0PuZ+z9pTdpXvDqWrPSEKW94m9kguIwjR4M/uRVJaIGtRFICh6/AC
        +wtetsWBKROzzwJm2cx1aOflXCiKjBs=
X-Google-Smtp-Source: APiQypKzPtnHIh+bzGEfLZgDiGHP8luMpKf8QhUEtcmHeKWIObN6zRUMS69wJeFTpM0D5av8KlZi9w==
X-Received: by 2002:a1c:4304:: with SMTP id q4mr1432462wma.152.1586250576643;
        Tue, 07 Apr 2020 02:09:36 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id q9sm12606640wrp.61.2020.04.07.02.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 02:09:36 -0700 (PDT)
Date:   Tue, 7 Apr 2020 11:09:35 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, davem@davemloft.net,
        kuba@kernel.org, mlxsw@mellanox.com
Subject: Re: [patch iproute2/net-next] devlink: fix JSON output of mon command
Message-ID: <20200407090935.GG2354@nanopsycho.orion>
References: <20200402095608.18704-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402095608.18704-1-jiri@resnulli.us>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen, this is also non net-next material. Please consider taking
directly to master.

Well make sure to send the patches with correct target next time.

Thanks!
