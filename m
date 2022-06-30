Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 086F5560EBE
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 03:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiF3Bof convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Jun 2022 21:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiF3Boc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 21:44:32 -0400
Received: from relay5.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E146922BD4
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 18:44:30 -0700 (PDT)
Received: from omf12.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay07.hostedemail.com (Postfix) with ESMTP id D64CE21072;
        Thu, 30 Jun 2022 01:44:26 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf12.hostedemail.com (Postfix) with ESMTPA id 5CB071D;
        Thu, 30 Jun 2022 01:44:15 +0000 (UTC)
Message-ID: <1a1f24707a03c2363e29ef91905e9f206fb6a0b5.camel@perches.com>
Subject: Re: [PATCH] remove CONFIG_ANDROID
From:   Joe Perches <joe@perches.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Kalesh Singh <kaleshsingh@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Theodore Ts'o <tytso@mit.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, rcu <rcu@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, sultan@kerneltoast.com,
        android-kernel-team <android-kernel-team@google.com>,
        John Stultz <jstultz@google.com>,
        Saravana Kannan <saravanak@google.com>, rafael@kernel.org
Date:   Wed, 29 Jun 2022 18:44:14 -0700
In-Reply-To: <YrzzWmQ9+uDRlO5K@zx2c4.com>
References: <Yrx8/Fyx15CTi2zq@zx2c4.com> <20220629163007.GA25279@lst.de>
         <Yrx/8UOY+J8Ao3Bd@zx2c4.com> <YryNQvWGVwCjJYmB@zx2c4.com>
         <Yryic4YG9X2/DJiX@google.com> <Yry6XvOGge2xKx/n@zx2c4.com>
         <CAC_TJve_Jk0+XD7VeSJVvJq4D9ZofnH69B4QZv2LPT4X3KNfeg@mail.gmail.com>
         <YrzaCRl9rwy9DgOC@zx2c4.com>
         <CAC_TJvcEzp+zQp50wtj4=7b6vEObpJCQYLaTLhHJCxFdk3TgPg@mail.gmail.com>
         <306dacfb29c2e38312943fa70d419f0a8d5ffe82.camel@perches.com>
         <YrzzWmQ9+uDRlO5K@zx2c4.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Stat-Signature: zbdp5d9fuytdswy6hfx17qhqzd7ozzw8
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 5CB071D
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19rCBqUb9HrdxbUJs3SdsgdKdwaYSpMY7s=
X-HE-Tag: 1656553455-953600
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-06-30 at 02:50 +0200, Jason A. Donenfeld wrote:
> On Wed, Jun 29, 2022 at 05:36:57PM -0700, Joe Perches wrote:
> > > > +static ssize_t pm_userspace_autosleeper_show(struct kobject *kobj,
> > > > +                               struct kobj_attribute *attr, char *buf)
> > > > +{
> > > > +       return sprintf(buf, "%d\n", pm_userspace_autosleeper_enabled);
> > 
> > This should use sysfs_emit no?
> 
> Probably, yea. Note that I just copy and pasted a nearby function,
> pm_async_show, `:%s/`d the variable name, and then promptly `git diff |
> clip`d it and plonked it into my email. Looking at the file, it uses
> sprintf all over the place in this fashion. So you may want to submit a
> cleanup to Rafael on this if you're right about sysfs_emit() being
> universally preferred.

Perhaps:

(trivial refactored and added a missing newline in autosleep_show)

---
 kernel/power/main.c | 102 ++++++++++++++++++++++++++--------------------------
 1 file changed, 52 insertions(+), 50 deletions(-)

diff --git a/kernel/power/main.c b/kernel/power/main.c
index e3694034b7536..c8a030319b15c 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -100,7 +100,7 @@ int pm_async_enabled = 1;
 static ssize_t pm_async_show(struct kobject *kobj, struct kobj_attribute *attr,
 			     char *buf)
 {
-	return sprintf(buf, "%d\n", pm_async_enabled);
+	return sysfs_emit(buf, "%d\n", pm_async_enabled);
 }
 
 static ssize_t pm_async_store(struct kobject *kobj, struct kobj_attribute *attr,
@@ -124,27 +124,25 @@ power_attr(pm_async);
 static ssize_t mem_sleep_show(struct kobject *kobj, struct kobj_attribute *attr,
 			      char *buf)
 {
-	char *s = buf;
+	int len = 0;
 	suspend_state_t i;
 
 	for (i = PM_SUSPEND_MIN; i < PM_SUSPEND_MAX; i++) {
 		if (i >= PM_SUSPEND_MEM && cxl_mem_active())
 			continue;
-		if (mem_sleep_states[i]) {
-			const char *label = mem_sleep_states[i];
+		if (!mem_sleep_states[i])
+			continue;
 
-			if (mem_sleep_current == i)
-				s += sprintf(s, "[%s] ", label);
-			else
-				s += sprintf(s, "%s ", label);
-		}
+		len += sysfs_emit_at(buf, len,
+				     mem_sleep_current == i ? "[%s] " : "%s ",
+				     mem_sleep_states[i]);
 	}
 
-	/* Convert the last space to a newline if needed. */
-	if (s != buf)
-		*(s-1) = '\n';
+	/* Convert the last space to a newline if needed */
+	if (len)
+		sysfs_emit_at(buf, len - 1, "\n");
 
-	return (s - buf);
+	return len;
 }
 
 static suspend_state_t decode_suspend_state(const char *buf, size_t n)
@@ -205,7 +203,7 @@ bool sync_on_suspend_enabled = !IS_ENABLED(CONFIG_SUSPEND_SKIP_SYNC);
 static ssize_t sync_on_suspend_show(struct kobject *kobj,
 				   struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", sync_on_suspend_enabled);
+	return sysfs_emit(buf, "%d\n", sync_on_suspend_enabled);
 }
 
 static ssize_t sync_on_suspend_store(struct kobject *kobj,
@@ -242,22 +240,22 @@ static const char * const pm_tests[__TEST_AFTER_LAST] = {
 static ssize_t pm_test_show(struct kobject *kobj, struct kobj_attribute *attr,
 				char *buf)
 {
-	char *s = buf;
+	int len = 0;
 	int level;
 
-	for (level = TEST_FIRST; level <= TEST_MAX; level++)
-		if (pm_tests[level]) {
-			if (level == pm_test_level)
-				s += sprintf(s, "[%s] ", pm_tests[level]);
-			else
-				s += sprintf(s, "%s ", pm_tests[level]);
-		}
+	for (level = TEST_FIRST; level <= TEST_MAX; level++) {
+		if (!pm_tests[level])
+			continue;
+		len += sysfs_emit_at(buf, len,
+				     level == pm_test_level ? "[%s] " : "%s ",
+				     pm_tests[level]);
+	}
 
-	if (s != buf)
-		/* convert the last space to a newline */
-		*(s-1) = '\n';
+	/* convert the last space to a newline if needed */
+	if (len)
+		sysfs_emit_at(buf, len - 1, "\n");
 
-	return (s - buf);
+	return len;
 }
 
 static ssize_t pm_test_store(struct kobject *kobj, struct kobj_attribute *attr,
@@ -314,7 +312,7 @@ static char *suspend_step_name(enum suspend_stat_step step)
 static ssize_t _name##_show(struct kobject *kobj,		\
 		struct kobj_attribute *attr, char *buf)		\
 {								\
-	return sprintf(buf, "%d\n", suspend_stats._name);	\
+	return sysfs_emit(buf, "%d\n", suspend_stats._name);	\
 }								\
 static struct kobj_attribute _name = __ATTR_RO(_name)
 
@@ -339,7 +337,7 @@ static ssize_t last_failed_dev_show(struct kobject *kobj,
 	index %= REC_FAILED_NUM;
 	last_failed_dev = suspend_stats.failed_devs[index];
 
-	return sprintf(buf, "%s\n", last_failed_dev);
+	return sysfs_emit(buf, "%s\n", last_failed_dev);
 }
 static struct kobj_attribute last_failed_dev = __ATTR_RO(last_failed_dev);
 
@@ -353,7 +351,7 @@ static ssize_t last_failed_errno_show(struct kobject *kobj,
 	index %= REC_FAILED_NUM;
 	last_failed_errno = suspend_stats.errno[index];
 
-	return sprintf(buf, "%d\n", last_failed_errno);
+	return sysfs_emit(buf, "%d\n", last_failed_errno);
 }
 static struct kobj_attribute last_failed_errno = __ATTR_RO(last_failed_errno);
 
@@ -369,7 +367,7 @@ static ssize_t last_failed_step_show(struct kobject *kobj,
 	step = suspend_stats.failed_steps[index];
 	last_failed_step = suspend_step_name(step);
 
-	return sprintf(buf, "%s\n", last_failed_step);
+	return sysfs_emit(buf, "%s\n", last_failed_step);
 }
 static struct kobj_attribute last_failed_step = __ATTR_RO(last_failed_step);
 
@@ -477,7 +475,7 @@ bool pm_print_times_enabled;
 static ssize_t pm_print_times_show(struct kobject *kobj,
 				   struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", pm_print_times_enabled);
+	return sysfs_emit(buf, "%d\n", pm_print_times_enabled);
 }
 
 static ssize_t pm_print_times_store(struct kobject *kobj,
@@ -510,7 +508,7 @@ static ssize_t pm_wakeup_irq_show(struct kobject *kobj,
 	if (!pm_wakeup_irq())
 		return -ENODATA;
 
-	return sprintf(buf, "%u\n", pm_wakeup_irq());
+	return sysfs_emit(buf, "%u\n", pm_wakeup_irq());
 }
 
 power_attr_ro(pm_wakeup_irq);
@@ -520,7 +518,7 @@ bool pm_debug_messages_on __read_mostly;
 static ssize_t pm_debug_messages_show(struct kobject *kobj,
 				      struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", pm_debug_messages_on);
+	return sysfs_emit(buf, "%d\n", pm_debug_messages_on);
 }
 
 static ssize_t pm_debug_messages_store(struct kobject *kobj,
@@ -568,21 +566,24 @@ struct kobject *power_kobj;
 static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
 			  char *buf)
 {
-	char *s = buf;
+	int len = 0;
 #ifdef CONFIG_SUSPEND
 	suspend_state_t i;
 
-	for (i = PM_SUSPEND_MIN; i < PM_SUSPEND_MAX; i++)
+	for (i = PM_SUSPEND_MIN; i < PM_SUSPEND_MAX; i++) {
 		if (pm_states[i])
-			s += sprintf(s,"%s ", pm_states[i]);
+			len += sysfs_emit_at(buf, len, "%s ", pm_states[i]);
+	}
 
 #endif
 	if (hibernation_available())
-		s += sprintf(s, "disk ");
-	if (s != buf)
-		/* convert the last space to a newline */
-		*(s-1) = '\n';
-	return (s - buf);
+		len += sysfs_emit_at(buf, len, "disk ");
+
+	/* convert the last space to a newline if needed */
+	if (len)
+		sysfs_emit_at(buf, len - 1, "\n");
+
+	return len;
 }
 
 static suspend_state_t decode_state(const char *buf, size_t n)
@@ -681,8 +682,10 @@ static ssize_t wakeup_count_show(struct kobject *kobj,
 {
 	unsigned int val;
 
-	return pm_get_wakeup_count(&val, true) ?
-		sprintf(buf, "%u\n", val) : -EINTR;
+	if (!pm_get_wakeup_count(&val, true))
+		return -EINTR;
+
+	return sysfs_emit(buf, "%u\n", val);
 }
 
 static ssize_t wakeup_count_store(struct kobject *kobj,
@@ -724,17 +727,16 @@ static ssize_t autosleep_show(struct kobject *kobj,
 	suspend_state_t state = pm_autosleep_state();
 
 	if (state == PM_SUSPEND_ON)
-		return sprintf(buf, "off\n");
+		return sysfs_emit(buf, "off\n");
 
 #ifdef CONFIG_SUSPEND
 	if (state < PM_SUSPEND_MAX)
-		return sprintf(buf, "%s\n", pm_states[state] ?
-					pm_states[state] : "error");
+		return sysfs_emit(buf, "%s\n", pm_states[state] ?: "error");
 #endif
 #ifdef CONFIG_HIBERNATION
-	return sprintf(buf, "disk\n");
+	return sysfs_emit(buf, "disk\n");
 #else
-	return sprintf(buf, "error");
+	return sysfs_emit(buf, "error\n");
 #endif
 }
 
@@ -803,7 +805,7 @@ int pm_trace_enabled;
 static ssize_t pm_trace_show(struct kobject *kobj, struct kobj_attribute *attr,
 			     char *buf)
 {
-	return sprintf(buf, "%d\n", pm_trace_enabled);
+	return sysfs_emit(buf, "%d\n", pm_trace_enabled);
 }
 
 static ssize_t
@@ -840,7 +842,7 @@ power_attr_ro(pm_trace_dev_match);
 static ssize_t pm_freeze_timeout_show(struct kobject *kobj,
 				      struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%u\n", freeze_timeout_msecs);
+	return sysfs_emit(buf, "%u\n", freeze_timeout_msecs);
 }
 
 static ssize_t pm_freeze_timeout_store(struct kobject *kobj,

