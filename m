Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 412458CB7C
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 07:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfHNF7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 01:59:41 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43571 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbfHNF7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 01:59:40 -0400
Received: by mail-wr1-f67.google.com with SMTP id y8so3948986wrn.10
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 22:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UzHE6Nq21WslpH6dbZt50zJyG00AQbKoTsQ1AHR4hEs=;
        b=vZWSQ4SGzvh9l1M7W6v5IizAOosYjglzKC4oX/cuagbwD9Dusgqi71memi83ovdxB+
         RS/RjUG1E6Rsgs1k7I3LQoj21h/DrDUmU0YNy/2ZPZE8Cph2BIM8B5DxRrNNj8A69wzj
         QUQLuzM6RXIv9i+h2lH677/kzs5ttrSGPaE/jmp+6A3hAp20OP2SjWCND047iguDSSOr
         qLFOnp7QTvFbjKhS6LHuPmbI10m+GXFW3NHXUN5EEQ2sw/wussvVEYTRutd/8cYXA5X2
         GN8pqHy52dx8aVj5Nhzv1x//GCgsGNQZRcwoTSbHItCMuZOihYX3t+UjsvaAvY3flbEn
         H+DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UzHE6Nq21WslpH6dbZt50zJyG00AQbKoTsQ1AHR4hEs=;
        b=JO1nEVgZm/qgnejYwG+ZiHtkj8oVNtKrPis8+GeRt7YSJkWXiIr/y07T+aNsJpJLFg
         oQ8JFNRH1YTLaWGA3z5prD7M4aGzt6VoL5WGLx9jnNjQbSs3kxwSUgYE8g+KA4rXZJK3
         JPKR1EHegIJ8zmvVAw9ZsXaJaKESWpxkTAEcIZC56TCxt7IQ1GsQShSduLSdBP5fqlA9
         uQD2WbfHNGs2fGyMrcq+KpsSJ3RafcCd+njL0jq47K/TiU5ktUsq7hMtfw7nD1yIj2/t
         stLWA7EhN1JWbT8/sAQbZLD3z0qj0BT4eOOFzVSwxWlD50xZe9dRwpooG8LfQ/S6lsBI
         r6VQ==
X-Gm-Message-State: APjAAAX30lXMk6PSaFeG4pVlOqz3LqV58ACPUqt+0QRfTZEydOEXWRb1
        ZWZ0iXhKlENhW5JKOFvCVzAjFA==
X-Google-Smtp-Source: APXvYqwd3K70jb2YRjFwUgXbUSKVdipdRdti4wr3V+zyJa2X6x1n7HOxKerGK/3l1byyjy1AMJdFBw==
X-Received: by 2002:adf:f7cd:: with SMTP id a13mr27719969wrq.165.1565762378860;
        Tue, 13 Aug 2019 22:59:38 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id 2sm2919240wmz.16.2019.08.13.22.59.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 22:59:38 -0700 (PDT)
Date:   Wed, 14 Aug 2019 07:59:37 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 1/2] netdevsim: implement support for devlink
 region and snapshots
Message-ID: <20190814055937.GT2428@nanopsycho>
References: <20190813144843.28466-1-jiri@resnulli.us>
 <20190813144843.28466-2-jiri@resnulli.us>
 <20190813150829.1012188c@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813150829.1012188c@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Aug 14, 2019 at 12:08:29AM CEST, jakub.kicinski@netronome.com wrote:
>On Tue, 13 Aug 2019 16:48:42 +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Implement dummy region of size 32K and allow user to create snapshots
>> or random data using debugfs file trigger.
>> 
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>
>Hmm.. did you send the right version?

You are right. I apologize.
