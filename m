Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1A5F1A137E
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 20:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgDGSYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 14:24:39 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43890 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgDGSYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 14:24:38 -0400
Received: by mail-pg1-f196.google.com with SMTP id s4so2103315pgk.10
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 11:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=klH2+VVQ7YI+E5OplrQAv+yI2sRrP7vLPFFbxA7AMro=;
        b=x3OLlMZX8e4SxCXa27frEUKupCI6KSaiMSxwRDBZ7zNYIZsq6q8vaQ5KCsu+0GjCOw
         eWnXjBi5fbHg0gUw7XW1tWGnKHnwE5kFjQAreN+09P+P9Q8+Yx5H4NcYmu2ENt68yIiR
         9s4t1eXKDJpBHkMkZ5HKdbhk4OhLCIXgKr35Hh7/GlsT2G9P23I618XQaPHxl1Sft0Ji
         jh8I0jJrDhFq01bJUEPSiWFjsQ95NGW0ATztibySIynrKNe2edk5J3gBcMD5EhwusdUS
         +sEIPOmqhB7B+uxSv8gruiIidB6nICbO4Rhi5KkuUz6M2438LkIVIPSQKGDBwj8C3ceb
         j+EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=klH2+VVQ7YI+E5OplrQAv+yI2sRrP7vLPFFbxA7AMro=;
        b=q/me+nKdj3ehH/fz2Hut7awpfI7JEaC9tM5AfOtg8F7lFFPV5pDwqzPo8C5aY+OY+q
         ZOE4REs1DHWm1Kne+n0R8mTVICxvA68xtEPqtj3LGcsKCzCJuDbz/AZmVPj3Odt9qnEM
         Z6X27PI57WMcnGOXlCK68+UFWs+1WpoUJGjixOy9h/mYmk1QFZrj4aGKWgsenl6iIl3c
         CWZYBnLPeWkEWzE30G/lzxSpMoT09ZlSlnKsSOAnWegxaOieIJNu0OhnuKAn9CS10YSW
         PZE1+UU6xfnsbwWAlEofVIYKfWArQVC2ZaFgEdZ+AM/g+IV64VbhNuWCn2UlULWI5iJw
         d7zQ==
X-Gm-Message-State: AGi0PuYzjt/dvGxVDG6cGi4CrMgIFghv/z7e4JHwWOGujfwnb727YWe5
        mkwQ9d6Xvx7YKyerbstvRPXpaIo8qxWZxA==
X-Google-Smtp-Source: APiQypI4OEAczTVJYYKxZdhcYNfvzAS4TmfJJd10Mr7ImSCNcDIvj6sdFXEWfWMJSB8fj+L4v1nEcw==
X-Received: by 2002:a63:60d:: with SMTP id 13mr3254255pgg.151.1586283876249;
        Tue, 07 Apr 2020 11:24:36 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id h95sm2214150pjb.46.2020.04.07.11.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 11:24:35 -0700 (PDT)
Date:   Tue, 7 Apr 2020 11:24:27 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 1/2] man: add ip-netns(8) as generation target
Message-ID: <20200407112427.403c73c9@hermes.lan>
In-Reply-To: <20200407174306.145032-1-briannorris@chromium.org>
References: <20200407174306.145032-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Apr 2020 10:43:05 -0700
Brian Norris <briannorris@chromium.org> wrote:

> Prepare for adding new variable substitutions. Unify the sed rules while
> we're at it, since there's no need to write this out 4 times.
> 
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Why is this needed?
