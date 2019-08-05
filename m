Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13DE48120D
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 08:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfHEGCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 02:02:41 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37802 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfHEGCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 02:02:41 -0400
Received: by mail-wm1-f67.google.com with SMTP id f17so71705822wme.2
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 23:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rYbLHeGEkazMYqZpHw+axOUdiO9DJFjeR3HG13iSHYE=;
        b=nGb8EYn0j+RQBxVSCa1n1EyFmtdIfEuLUCX2KAp9y0Ioe/1pjs+rjP2GGOIpvBpzMY
         n/D1x6IGmixX2PpCZiPmcONWrwWI2udkFDZ8R5Z3zdrd5yR9DKwu7bR1PJgyxIXOfhQF
         od4We0x8lMkeEZov/thQXa6mbbBlKudqU86TQ3drDCtTZj/tWyA1O+YmjN7xpvojdifk
         iVHCBCpjUz7Z+x0mGaD5LxGTSJwMJtqBMc09oq8shNPs5JWdHCWpX2EPTsMwVjGs03Tn
         4H5gKNhaLlrjL2lsOE4zwU1i3VVGrxPHWp1wqstYEEVwNDkvY5OswQr+bbFZcEhCzcF9
         DhFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rYbLHeGEkazMYqZpHw+axOUdiO9DJFjeR3HG13iSHYE=;
        b=eF7/xsRAkFfUkONn7wJS85iiPTr96FxHGvEkaMl5z2mv0k+5+bOvpHYR5su0b6yaS4
         O7Z0NUrgIXPe5ZWkIv3vm5AVkvrWRUjnbaqKQfLxagDNE/5SoC2epn0opF6WRfmix+iT
         FQWSI+R/54Y8XVIxtRXMnykjato3vmiH42xs8kMljneCwSUWZiJrL4kL2Up2arikhXaO
         LbIxluvGdPasWhoh7fJZuCGJY7a5fDQ9W0kgfJAW3g9OGzKMZoSbKII4OmQ2+NPLKm1n
         U4GgX83q7COEdNavCqq4kC9zxeDgqKVusaeBuZbS7SSERkaYhwvQsUmqHVSZOOWK7+9V
         Xylw==
X-Gm-Message-State: APjAAAWgwO1m1YVg7BlCq/MP2eQLvD5P1lx5KU+YWWw57r4iErhgNAnO
        rnMh6hELIY5dlU6Y9Of1HoPwag==
X-Google-Smtp-Source: APXvYqwsDzjnqn7kQhQNISPjmml7diURISWzFQnEUhyPflTbdqCa8FD5Jm797JM/YiXzUIO52ZD5wQ==
X-Received: by 2002:a7b:c651:: with SMTP id q17mr15334256wmk.136.1564984959650;
        Sun, 04 Aug 2019 23:02:39 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id g8sm85255642wmf.17.2019.08.04.23.02.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 23:02:39 -0700 (PDT)
Date:   Mon, 5 Aug 2019 08:02:38 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, fw@strlen.de, jakub.kicinski@netronome.com,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/6] cls_api: add flow_indr_block_call function
Message-ID: <20190805060238.GB2349@nanopsycho.orion>
References: <1564628627-10021-1-git-send-email-wenxu@ucloud.cn>
 <1564628627-10021-4-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564628627-10021-4-git-send-email-wenxu@ucloud.cn>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Re subject. You don't have "v5" in this patch. I don't understand how
that happened. Do you use --subject-prefix in git-format-patch?
