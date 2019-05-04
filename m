Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3502F13B30
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 18:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfEDQcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 12:32:46 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:42473 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfEDQcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 12:32:46 -0400
Received: by mail-pg1-f174.google.com with SMTP id p6so4261982pgh.9
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 09:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=DYtH4JjBDASmvRSEsoRxzXHc0r2bMapDA+EWP6yFACo=;
        b=GyO3nOXERiGad4icOuo17PCutGrL6u5TLBP0Ujs2/hsv6sR/YtNbrxc1iVHfXrAPbD
         UyPMFb0rv4nqEnrHKUhBjmT2T/VU9ZP8dsEbwkuiIehAJ1VZSxf1uWJIJky7wb6UzIrN
         VnTZGRCZnfiQp9FS+S72WL/eZEP4SLofQvN+caKkSkUkd4rXNeHiCphv9bc47g6Dmhc7
         /kT7qKVz3NSAybClsJJ7rSyP5DTnz8HB7ETapZDK5is3jhlGqUxZHI5NH2FUUp8/Uvwa
         WzVY0aNvZQtakueFLXqLUTfAR1PcD8DnIWLMFVWOdk7WcxW8toSAs9/JFkfEEmsg3oAR
         38LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DYtH4JjBDASmvRSEsoRxzXHc0r2bMapDA+EWP6yFACo=;
        b=biBkEFOGBJLQqIUrs+8T1YLn40agDQ0+CnL5SZcyRkAsKLOCKOLfql4uCmV8HUjcf5
         N8VB9b0UHDJ6lJ2ma0jFdHuBaat4qqgdBmP09+fkTKUIs1FajDiRCPjDIlfXDqhc/g2X
         5uf/eAE9XkfbO5zPJ/OfULh1LIY1wLwUmy0k2tG9KsVhFpRL7lmJ4Kc8Xk2jkAx6ZW73
         Ufe3sfGPGP9vFNr2n19ux3t82g01cemgn+IaDvCEmtT/9pRUTkaruwlWBVdu+tBvtaf9
         9L5kWHGLUbz4SM2uA3imCqXJb3F+SgMuUjhZpTkVaWfnrs+QB00dZo+KdZIhomMjhLiY
         ciBQ==
X-Gm-Message-State: APjAAAXi0KWMQER6IeGmarwJ1WQqJWucZ0uEZAvrO1vMfE/I1F0/2Zpa
        zbjRyJz0cEizsrsQSgYGKRA16G/L
X-Google-Smtp-Source: APXvYqwOYmWX/a6XLn0rmy98/APd3Zc1EwtG7Kq8ZrFQE3INnK/FK5Ra17VFwwt7W7XYigkcnvNJ1w==
X-Received: by 2002:a63:360c:: with SMTP id d12mr19312663pga.404.1556987565363;
        Sat, 04 May 2019 09:32:45 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id y3sm8849307pge.7.2019.05.04.09.32.43
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 09:32:44 -0700 (PDT)
Subject: Re: CVE-2019-11683
To:     Reindl Harald <h.reindl@thelounge.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
References: <7a1c575b-b341-261c-1f22-92d656d6d9ae@thelounge.net>
 <0ca5c3b7-49e5-6fdd-13ba-4aaee72f2060@gmail.com>
 <f81bad23-97d5-1b2b-20a1-f29cfc63ff79@thelounge.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f84d6562-3108-df30-36f7-0580bd6ea4e2@gmail.com>
Date:   Sat, 4 May 2019 12:32:43 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <f81bad23-97d5-1b2b-20a1-f29cfc63ff79@thelounge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/19 12:13 PM, Reindl Harald wrote:
> 
> 
> 
> ok, so the answer is no
> 
> what's the point then release every 2 days a new "stable" kernel?
> even distributions like Fedora are not able to cope with that

That is a question for distros, not for netdev@ ?


