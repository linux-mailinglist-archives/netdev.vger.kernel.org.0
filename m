Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEC41A3080
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 09:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgDIHxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 03:53:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56038 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgDIHxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 03:53:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=j1u1dstHhiu5YZMP7Sxp4XViDRC+d/D8RY2exODY4Q4=; b=plyLyiFlp0SaPTKUWYgeuSAW7y
        8r57A09VcmjwIWAb1jVRdNlnXtb0riAyy76y5jpm/Adg34YwQWc0TLSNsyZZEsuCv/47r9Hbuk7MR
        xMdsTGlrjeFmDwhxQAwcQzo+6TC6kIJUga5f+JMo+nuKA3hKaTJFiIgChv5xn3zJbNvpJ3xCSxQNC
        akr56YQvjHrhQqJrlOYVl3+SdwAQxq5a2CdW50SH7j4fv55Dz+X4Darw86gw29NoFoQGakeOUAgXR
        sI/OTswM/ZfGEhdmheBRoddOhnvghyj+OnioMB6NsHW8m8ar2g/9xvdoglvGkfSa2bomXYvOnY9wU
        fO47p6nA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMS00-00076J-7N; Thu, 09 Apr 2020 07:53:20 +0000
Date:   Thu, 9 Apr 2020 00:53:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/8] loopfs: implement loopfs
Message-ID: <20200409075320.GA26234@infradead.org>
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
 <20200408152151.5780-3-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408152151.5780-3-christian.brauner@ubuntu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Almost 600 lines of code for a little bit of fine grained control
is the wrong tradeoff.  Please find a cheaper way to do this.
