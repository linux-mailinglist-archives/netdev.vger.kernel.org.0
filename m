Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA8751C2C
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 22:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730084AbfFXUT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 16:19:57 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40122 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfFXUT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 16:19:57 -0400
Received: by mail-qt1-f193.google.com with SMTP id a15so15937922qtn.7
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 13:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=J+31yiVIpeZaBht9PTvBAvhP2K+vK6pX5ursKQcNMl4=;
        b=qk/1TkIPEhkOKXhwf8AHMhUTW4zO8KlTzcRtkaIgAulC0NFS8zZ0I5B+UpqlIkJCzL
         BkYDfwEf9iV0LrZStBJJBQjpcLgc+G4As5TjXyAxuacmD+DM7d+GJKAibByJPeuAhezA
         ofEHWZKrgb6jgvS9mbn8aDybd67heXG436o/fOcJdATBetO3c3vN4biYxO36UGjC/QFW
         bQ+d8fLRnEcPHmFRdzygnxN7UoXBHgwhQIzFxQ6XpymJiPzGJpJbSpC4lgvujxCNtLPo
         4u20SY591LbHSJOrJ8Jb8J4Qj3NAZDebbwtJG+a7sHUVqo+I9k3ZYZJURDi+Ae9s0lz5
         jVWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=J+31yiVIpeZaBht9PTvBAvhP2K+vK6pX5ursKQcNMl4=;
        b=U+FAz0SHB/JgqwnRaQ+3TPr0hgmkPgWmBjvQmaz/8/EEOR8C0t7ZktW04uGLX+hexw
         EpKOWW9W5N0WmSbJBLHFjdwa8Q4pVJXz70Km0jlzU9Ze0cDQ1uKmdXUWus8Vg492BUOk
         Hh9wZ/mWWf6KyIu3vrKYtj1G3X3HIyesIYPqxHBAt2OnAFdOZR9koZEco/2SjDmOTwg9
         is8G2DI+jbYoxJIb9UwDAEGaXxz1npMBgpbs6MIGbmAig6RyImPw/44gIPwlMc6lksFB
         XNymnuKa8ZVmUZlukaJrfaNF6Mpz0C2I/10YtMbs5pZIwnP6iWdd3tdSQE8IbO0w0DnF
         t/9A==
X-Gm-Message-State: APjAAAXEJbH3HD6rQ5G5XLcPx4O1AKkBkjR9T/T9VPm6yYNP/GXW3LKI
        aRCkko/H4iG/tvjAP/r/pMoKrw==
X-Google-Smtp-Source: APXvYqxG95CQ9zrP7JXYRgZulZS9NJZFgY4n/fOLNNHYIYY8fmP8zHIwrYsNviL3ILfmObPyyZeKeg==
X-Received: by 2002:a0c:99e6:: with SMTP id y38mr22783496qve.42.1561407596055;
        Mon, 24 Jun 2019 13:19:56 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p31sm7975226qtk.55.2019.06.24.13.19.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 13:19:55 -0700 (PDT)
Date:   Mon, 24 Jun 2019 13:19:52 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 00/18] Add ionic driver
Message-ID: <20190624131952.0b90206e@cakuba.netronome.com>
In-Reply-To: <20190620202424.23215-1-snelson@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 13:24:06 -0700, Shannon Nelson wrote:
>  28 files changed, 9970 insertions(+)

Dave, could we consider setting a LoC limit for series and patches?
I know this is a new driver, but there's gotta be a way to split 
this up more, even if it's painful for the submitter :S

All the debugfs stuff shouldn't be necessary in the first version,
just looking at first 2 patches...
